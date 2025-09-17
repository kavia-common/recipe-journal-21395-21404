# IMPORTANT: Supabase Configuration Required

1) Set environment variables

Frontend (React):
- REACT_APP_SUPABASE_URL=<your-supabase-project-url>
- REACT_APP_SUPABASE_ANON_KEY=<your-anon-key>
- REACT_APP_SITE_URL=http://localhost:3000

OR Next.js:
- NEXT_PUBLIC_SUPABASE_URL=<your-supabase-project-url>
- NEXT_PUBLIC_SUPABASE_ANON_KEY=<your-anon-key>
- NEXT_PUBLIC_SITE_URL=http://localhost:3000

Backend (server-side):
- SUPABASE_URL=<your-supabase-project-url>
- SUPABASE_SERVICE_ROLE_KEY=<your-service-role-key>
- SITE_URL=http://localhost:3000

2) Supabase Dashboard
- Authentication → URL Configuration:
  - Site URL: http://localhost:3000/
  - Redirect URLs: 
    * http://localhost:3000/**
    * https://yourapp.com/**

3) Database
- The public.recipes table has been provisioned with RLS enforced.
- Users can only access rows where user_id = auth.uid().

4) Snippet (React)
```js
// src/utils/getURL.js
export const getURL = () => {
  let url = process.env.REACT_APP_SITE_URL || 'http://localhost:3000'
  if (!url.startsWith('http')) url = `https://${url}`
  if (!url.endsWith('/')) url = `${url}/`
  return url
}

// src/utils/supabase.js
import { createClient } from '@supabase/supabase-js'
export const supabase = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.REACT_APP_SUPABASE_ANON_KEY
)
```

5) Auth helpers (examples)
```js
import { supabase } from './utils/supabase'
import { getURL } from './utils/getURL'

export const signUp = (email, password) =>
  supabase.auth.signUp({ email, password, options: { emailRedirectTo: `${getURL()}auth/callback` }})
```

Refer to assets/supabase.md for the full schema and policies.
