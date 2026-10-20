import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, apikey, content-type, x-client-info",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Content-Type": "application/json",
};
const json = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), { status, headers: corsHeaders });

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: corsHeaders });
  if (req.method !== "POST") return json(405, { error: "Method not allowed." });
  let body: { question_date?: string };
  try { body = await req.json(); } catch { return json(400, { error: "Invalid JSON body." }); }
  const date = body.question_date || "";
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date)) return json(400, { error: "A valid YYYY-MM-DD challenge date is required." });

  // Public endpoint by design: enforce the release schedule before accessing solution data.
  const parts = new Intl.DateTimeFormat("en-GB", {
    timeZone: "Asia/Kolkata", year: "numeric", month: "2-digit", day: "2-digit",
    hour: "2-digit", hourCycle: "h23",
  }).formatToParts(new Date()).filter((p) => p.type !== "literal");
  const india = Object.fromEntries(parts.map((p) => [p.type, p.value]));
  const today = String(india.year) + "-" + String(india.month) + "-" + String(india.day);
  const hour = Number(india.hour);
  if (date > today || (date === today && hour < 18)) {
    return json(200, { solution: null, released: false });
  }

  const url = Deno.env.get("SUPABASE_URL");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !serviceRoleKey) return json(500, { error: "Solution service is not configured." });
  const admin = createClient(url, serviceRoleKey, { auth: { persistSession: false, autoRefreshToken: false } });
  const { data, error } = await admin.from("daily_questions")
    .select("solution")
    .eq("question_date", date)
    .eq("is_live", true)
    .eq("solution_published", true)
    .maybeSingle();
  if (error) return json(500, { error: "Could not load the released solution." });
  return json(200, { solution: data?.solution || null, released: !!data?.solution });
});
