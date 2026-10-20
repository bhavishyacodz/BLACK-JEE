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
  const url = Deno.env.get("SUPABASE_URL");
  const anonKey = Deno.env.get("SUPABASE_ANON_KEY");
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !anonKey || !serviceRoleKey) return json(500, { error: "Server configuration is incomplete. No records were changed." });
  const authHeader = req.headers.get("Authorization") || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : "";
  if (!token) return json(401, { error: "Sign in as the dashboard owner first." });
  const authClient = createClient(url, anonKey, { auth: { persistSession: false, autoRefreshToken: false } });
  const { data: authData, error: authError } = await authClient.auth.getUser(token);
  if (authError || !authData.user || authData.user.app_metadata?.role !== "admin") {
    return json(403, { error: "Admin permission verification failed. No records were changed." });
  }
  let input: { action?: string; scope?: string; ids?: string[]; id?: string };
  try { input = await req.json(); } catch { return json(400, { error: "Invalid JSON body." }); }
  const admin = createClient(url, serviceRoleKey, { auth: { persistSession: false, autoRefreshToken: false } });
  let query = admin.from("attempt_submissions").select("id, photo_path, is_reviewed, is_public").order("created_at", { ascending: true });
  if (input.action === "single") {
    if (!input.id || typeof input.id !== "string") return json(400, { error: "A submission ID is required." });
    query = query.eq("id", input.id);
  } else if (input.action === "bulk") {
    if (!Array.isArray(input.ids) || input.ids.length === 0 || input.ids.length > 50000 || !input.ids.every((id) => typeof id === "string" && id.length <= 80)) return json(400, { error: "Invalid or empty cleanup selection." });
    if (!["pending", "reviewed", "all"].includes(input.scope || "")) return json(400, { error: "Unsupported cleanup scope." });
    query = query.in("id", input.ids);
    if (input.scope === "pending") query = query.eq("is_reviewed", false).eq("is_public", false);
    if (input.scope === "reviewed") query = query.eq("is_reviewed", true).eq("is_public", false);
  } else return json(400, { error: "Unsupported cleanup action." });
  const rows: Array<{ id: string; photo_path: string | null; is_reviewed: boolean; is_public: boolean }> = [];
  for (let offset = 0; ; offset += 500) {
    const { data, error } = await query.range(offset, offset + 499);
    if (error) return json(500, { error: "Could not safely load selected submissions. No records were deleted." });
    rows.push(...(data || []));
    if (!data || data.length < 500) break;
  }
  if (!rows.length) return json(200, { deletedCount: 0, photosDeleted: 0, message: "No matching submissions." });
  const paths = [...new Set(rows.map((r) => r.photo_path).filter((p): p is string => !!p))];
  let photosDeleted = 0;
  for (let i = 0; i < paths.length; i += 100) {
    const batch = paths.slice(i, i + 100);
    const { error } = await admin.storage.from("attempt-photos").remove(batch);
    if (error) return json(502, { error: "Storage photo cleanup failed. Database rows were retained. If earlier photo batches completed, those photos may already be gone; check Storage and retry.", photosRemovedBeforeFailure: photosDeleted });
    photosDeleted += batch.length;
  }
  let deletedCount = 0;
  const ids = rows.map((r) => r.id);
  for (let i = 0; i < ids.length; i += 100) {
    const { data, error } = await admin.from("attempt_submissions").delete().in("id", ids.slice(i, i + 100)).select("id");
    if (error) return json(502, { error: "Photo cleanup completed, but database deletion failed. Some records may remain without their photo; refresh and retry.", deletedCount, photosDeleted });
    deletedCount += data?.length || 0;
  }
  return json(200, { deletedCount, photosDeleted, message: "Selected submissions and associated photos were removed." });
});
