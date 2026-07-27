# Mes Séries

Application web pour suivre les séries que tu regardes, façon TV Show Time :
recherche de séries (API [TVMaze](https://www.tvmaze.com/api), gratuite et sans clé),
suivi épisode par épisode, statuts, notes, calendrier des prochaines sorties, stats.

App 100% statique (HTML/CSS/JS, sans framework ni build), avec [Supabase](https://supabase.com)
comme base de données et système de comptes (email + mot de passe), pour retrouver ta
bibliothèque sur tous tes appareils.

## Mise en route (Supabase)

L'app ne fonctionne qu'une fois connectée à un projet Supabase — sans ça, l'écran de
connexion s'affiche avec un message "Configuration Supabase manquante".

1. **Crée un projet** sur [supabase.com](https://supabase.com) (gratuit, ~2 min pour
   qu'il soit prêt).
2. **Crée la table** : dans le projet, va dans *SQL Editor* → *New query*, colle le
   contenu de [`supabase-schema.sql`](supabase-schema.sql), puis *Run*. Ça crée la table
   `shows` avec la sécurité (RLS) qui garantit que chacun ne voit que ses propres séries.
3. **Active l'inscription par email** : *Authentication* → *Providers* → *Email* doit
   être activé (c'est le cas par défaut). Si tu veux éviter l'étape de confirmation par
   email pour un usage perso, tu peux désactiver *Confirm email* dans les réglages du
   provider.
4. **Récupère tes clés** : *Project Settings* → *API*. Copie *Project URL* et la clé
   *anon public* (cette clé est faite pour être exposée côté client — la sécurité vient
   des règles RLS créées à l'étape 2, pas du secret de la clé).
5. **Colle-les dans [`config.js`](config.js)** :
   ```js
   window.SUPABASE_URL = 'https://xxxxxxxxxxxx.supabase.co';
   window.SUPABASE_ANON_KEY = 'eyJhbGciOi...';
   ```
6. Ouvre `index.html`, crée ton compte depuis l'écran de connexion, et c'est parti.

## Déploiement (Vercel)

Le repo est prêt à être déployé tel quel (aucune étape de build) :

1. Pousse le repo sur GitHub (déjà fait si tu utilises ce dépôt).
2. Sur [vercel.com](https://vercel.com), *Add New* → *Project* → importe ce repo GitHub.
3. Laisse les réglages par défaut (Vercel détecte un site statique) et déploie.
4. Chaque `git push` sur la branche principale redéploie automatiquement.

`config.js` contenant tes clés Supabase (publiques par design), il est déployé avec le
reste du site sans configuration supplémentaire.

## Structure du projet

| Fichier | Rôle |
|---|---|
| `index.html` | Toute l'application (UI, logique, appels TVMaze/Supabase) |
| `config.js` | URL + clé anon de ton projet Supabase |
| `supabase-schema.sql` | Script SQL à exécuter une fois dans Supabase |
| `manifest.webmanifest`, `icon-*.png` | Icônes / installation en PWA |
| `sw.js` | Service worker (cache de l'app pour un chargement hors-ligne) |

## Fonctionnalités

- Recherche de séries via TVMaze, ajout avec récupération auto des saisons/épisodes
- Suivi épisode par épisode, saison par saison, avec passage automatique des statuts
  (à voir → en cours → terminé)
- Notation 5 étoiles
- Calendrier des prochains épisodes (jour de la semaine + heure de diffusion quand
  connue)
- Statistiques (temps de visionnage, épisodes vus, note moyenne…)
- Export/import JSON de secours, en plus du stockage Supabase
- Thème clair/sombre
