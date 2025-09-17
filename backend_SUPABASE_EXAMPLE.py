"""
Backend example using Supabase service role (for server-side operations).
Do NOT expose the service role key to the browser.
"""

import os
from supabase import create_client, Client  # pip install supabase

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_SERVICE_ROLE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

def get_supabase() -> Client:
    assert SUPABASE_URL, "SUPABASE_URL is required"
    assert SUPABASE_SERVICE_ROLE_KEY, "SUPABASE_SERVICE_ROLE_KEY is required"
    return create_client(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

def admin_list_user_recipes(user_id: str):
    supabase = get_supabase()
    resp = supabase.table("recipes").select("*").eq("user_id", user_id).execute()
    return resp.data
