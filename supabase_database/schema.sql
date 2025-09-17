-- Recipe Journal - Supabase schema (reference)

-- Table: public.recipes
CREATE TABLE IF NOT EXISTS public.recipes (
  id uuid DEFAULT gen_random_uuid(),
  user_id uuid,
  meal_id text,
  title text,
  thumbnail_url text,
  category text,
  area text,
  tags text[],
  source_url text,
  created_at timestamptz DEFAULT now(),
  notes text,
  rating int
);

-- Constraints and indexes
ALTER TABLE public.recipes ALTER COLUMN id SET NOT NULL;

DO $$
BEGIN
  ALTER TABLE public.recipes ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER TABLE public.recipes
    ADD CONSTRAINT recipes_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

ALTER TABLE public.recipes ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE public.recipes ALTER COLUMN meal_id SET NOT NULL;
ALTER TABLE public.recipes ALTER COLUMN title SET NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS recipes_user_meal_unique
  ON public.recipes(user_id, meal_id);

DO $$
BEGIN
  ALTER TABLE public.recipes ADD CONSTRAINT rating_range CHECK (rating BETWEEN 1 AND 5);
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

-- RLS
ALTER TABLE public.recipes ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  CREATE POLICY "Recipes select own" ON public.recipes
    FOR SELECT USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$
BEGIN
  CREATE POLICY "Recipes insert own" ON public.recipes
    FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$
BEGIN
  CREATE POLICY "Recipes update own" ON public.recipes
    FOR UPDATE USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

DO $$
BEGIN
  CREATE POLICY "Recipes delete own" ON public.recipes
    FOR DELETE USING (auth.uid() = user_id);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
