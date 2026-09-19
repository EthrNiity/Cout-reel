# Coût Réel

Application personnelle de gestion financière : calcul du vrai coût d'un achat,
calendrier de trésorerie, dettes, emprunts, épargne, budgets et objectifs.

Hébergée sur GitHub Pages, données sur Supabase, protégée par un vrai login.

---

## 1. Créer le projet Supabase

1. Va sur [supabase.com](https://supabase.com) et crée un compte (ou connecte-toi).
2. **New project** → choisis un nom (ex: `cout-reel`), un mot de passe de base de
   données (à noter quelque part), une région proche de toi (ex: `Europe West`).
3. Attends 1-2 minutes que le projet soit prêt.

## 2. Créer les tables

1. Dans le tableau de bord Supabase, va dans **SQL Editor** (menu de gauche).
2. Clique sur **New query**.
3. Ouvre le fichier `supabase-schema.sql` de ce dossier, copie tout son contenu,
   colle-le dans l'éditeur SQL, puis clique sur **Run**.
4. Vérifie dans **Table Editor** que les 9 tables sont bien créées
   (config, achats, depenses_fixes, echeances, budgets, epargnes, dettes,
   emprunts, objectifs).

## 3. Activer l'authentification par email

1. Va dans **Authentication** → **Providers**.
2. Vérifie que **Email** est activé (c'est le cas par défaut).
3. Optionnel mais recommandé pour un usage perso : dans **Authentication** →
   **Settings**, tu peux désactiver "Confirm email" pour te connecter
   immédiatement après la création du compte, sans avoir à cliquer sur un lien
   reçu par mail (à réactiver si tu partages un jour l'app).

## 4. Récupérer tes clés d'API

1. Va dans **Project Settings** (icône engrenage) → **API**.
2. Note deux valeurs :
   - **Project URL** (ex: `https://abcdefgh.supabase.co`)
   - **anon public key** (une longue chaîne de caractères)

## 5. Configurer le code

1. Ouvre `index.html` dans un éditeur de texte.
2. Cherche ces deux lignes tout en haut du `<script>` :
   ```js
   const SUPABASE_URL = 'https://TON-PROJET.supabase.co';
   const SUPABASE_ANON_KEY = 'TA_CLE_ANON_PUBLIQUE';
   ```
3. Remplace-les par tes vraies valeurs récupérées à l'étape 4.

> ℹ️ La clé "anon" est **conçue pour être publique** (elle sera visible dans le
> code sur GitHub) — c'est la Row Level Security (RLS), déjà configurée par le
> script SQL, qui empêche quiconque d'accéder aux données d'un autre compte.

## 6. Créer le dépôt GitHub

1. Sur [github.com](https://github.com), crée un **nouveau repository** (ex:
   `cout-reel`), public ou privé (privé fonctionne aussi avec GitHub Pages si
   tu as un compte payant ; sinon choisis public — le code n'a rien de secret
   grâce à la RLS).
2. Mets tous les fichiers de ce dossier à la racine du repo :
   - `index.html`
   - `manifest.json`
   - `icon.svg`
   - `service-worker.js`
   - `supabase-schema.sql` (optionnel, juste pour référence)
   - `README.md`
3. Commit et push.

## 7. Activer GitHub Pages

1. Dans le repo, va dans **Settings** → **Pages**.
2. Source : **Deploy from a branch**.
3. Branche : `main` (ou `master`), dossier `/ (root)`.
4. Sauvegarde. Après 1-2 minutes, ton app est en ligne à une adresse du type :
   `https://TON-PSEUDO.github.io/cout-reel/`

## 8. Créer ton compte dans l'app

1. Ouvre l'URL GitHub Pages.
2. Clique sur **Créer un compte**, renseigne ton email et un mot de passe.
3. Connecte-toi. Tu arrives directement sur l'app, vide et prête à configurer
   (onglet Config en premier lieu : salaire, solde actuel, etc.).

## 9. Installer l'app sur PC et sur ton Samsung

Une fois en ligne sur une vraie URL (et non plus dans l'aperçu Claude), les
navigateurs la reconnaissent comme une vraie PWA installable :

- **Chrome / Edge (PC)** : icône d'installation dans la barre d'adresse, ou
  menu ⋮ → **Installer Coût Réel**.
- **Chrome / Samsung Internet (Android)** : menu → **Ajouter à l'écran
  d'accueil** ou **Installer l'application**.
- **Opera** : n'a pas de vraie installation PWA sur PC ; épingle plutôt le
  site dans la barre latérale d'Opera, ou utilise Chrome/Edge juste pour
  cette app.

## Sauvegarde

L'onglet **Config** garde son bouton d'export/import JSON — utile pour une
sauvegarde ponctuelle en plus de Supabase (qui fait déjà des sauvegardes
automatiques de la base sur les plans payants).

## Sécurité

- Chaque table a une politique RLS qui restreint l'accès aux seules lignes
  dont `user_id` correspond à l'utilisateur connecté.
- Ne partage jamais le mot de passe de la base de données Postgres
  (différent du mot de passe de connexion à l'app) — il n'est nécessaire que
  pour des connexions directes avancées, pas pour l'usage normal de l'app.
