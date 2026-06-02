# Estado del proyecto `centro-medico-btp` — Handoff para continuación

> **Pegá este documento al inicio de la próxima conversación con Claude para retomar sin perder contexto.**

---

## Contexto general

**Usuario:** Marcos Farhat (Argentina, español rioplatense, dev SAP BTP).
**OS:** Windows 11 (PC "DracoPC", user "marco"). Usa PowerShell y Git Bash.
**Editor:** VS Code.
**Repo GitHub:** https://github.com/Marcosfarhat/centro-medico-cap-java
**Path local:** `C:\Users\marco\centro-medico-btp`

**Estilo de respuesta preferido:** Explicar cada comando (qué hace y por qué) incluso si se repite. Tabla para resumir cuando aplica. Cero asunciones.

---

## Estado del proyecto — Fases completadas

| Fase | Estado | Notas |
|------|--------|-------|
| 1: Entorno (Java 21 SapMachine, Node 22 LTS, Maven 3.9, CDS-DK 9.9.1, mbt 1.2.47, CF CLI 8.18) | ✅ | — |
| 2: Scaffold (`cds init centro-medico-btp --add java`) | ✅ | — |
| 3: Modelo CDS (4 entidades: Especialidades, Medicos, Pacientes, Turnos) | ✅ | — |
| 4: Datos CSV UTF-8 sin BOM | ✅ | — |
| 5: AdminService OData v4 en `/odata/v4/AdminService/` | ✅ | — |
| 6: Backend local Spring Boot puerto 8080 + H2 in-memory | ✅ | — |
| 7: Anotaciones Fiori UI + `@odata.draft.enabled` | ✅ | — |
| 8: App Fiori Elements local `adminturnosui` | ✅ | — |
| 9: AppRouter (`app/router/` con `xs-app.json` y `package.json`) | ✅ | — |
| 10: XSUAA + `xs-security.json` con scopes paciente/admin | ✅ | — |
| 11: `mta.yaml` raíz con módulos srv/router/db/uiapp | ✅ | — |
| 12: Build con `mbt build` + deploy con `cf deploy` a BTP Trial | ✅ parcial | srv+db+approuter deployados, app Fiori pendiente de resolver |
| 13: Crear Role Collections en BTP Cockpit y asignar al usuario | ⏳ | — |
| 14: App productiva accesible en BTP | ⏳ | — |

---

## Estructura actual del proyecto
C:\Users\marco\centro-medico-btp
├── .cdsrc.json
├── .gitignore
├── mta.yaml                                           ← MTA con readiness-health-check-type: process
├── xs-security.json                                   ← XSUAA con scopes admin/paciente + redirect-uris
├── package.json
├── pom.xml
├── db/
│   ├── schema.cds
│   ├── package.json                                   ← HDI deployer (@sap/hdi-deploy ^5)
│   ├── package-lock.json
│   └── data/
│       ├── com.centromedico-Especialidades.csv
│       ├── com.centromedico-Medicos.csv
│       ├── com.centromedico-Pacientes.csv
│       └── com.centromedico-Turnos.csv
├── srv/
│   ├── pom.xml
│   ├── service.cds                                    ← @requires: 'admin'
│   ├── fiori.cds
│   └── src/main/
│       ├── java/customer/centro_medico_btp/Application.java
│       └── resources/application.yaml
└── app/
├── services.cds
├── resources/                                     ← generado por mbt build (adminturnosui.zip)
└── adminturnosui/
├── package.json                               ← build: ui5 build && node zip-dist.js
├── zip-dist.js                                ← script que empaqueta dist/ en adminturnosui.zip
├── ui5.yaml
├── annotations.cds
├── webapp/
│   ├── manifest.json                          ← appId: adminturnosui
│   ├── xs-app.json                            ← xs-app.json dentro de la app (para HTML5 Repo)
│   ├── Component.js
│   ├── index.html
│   └── i18n/
└── dist/                                      ← generado por npm run build
└── router/
├── package.json                               ← @sap/approuter ^16
├── package-lock.json
├── xs-app.json                                ← localDir: adminturnosui
└── adminturnosui/                             ← copia de dist/ para servir estático

---

## Decisiones tomadas

- BD local: H2 in-memory. Target producción: HANA Cloud.
- Servicio único `AdminService` con `@requires: 'admin'`.
- Solo 1 app Fiori: `adminturnosui` para Turnos.
- `readiness-health-check-type: process` (no http) para evitar timeout en CF Trial.
- `start-timeout: 300` en el módulo srv.
- La app Fiori se copia a `app/router/adminturnosui/` y se sirve con `localDir` desde el AppRouter.
- `zip-dist.js` empaqueta `dist/` en `adminturnosui.zip` para el HTML5 Repo (también deployado pero no usado activamente).

---

## Apps deployadas en CF

| App | Estado | URL |
|-----|--------|-----|
| `centro-medico-btp-srv` | ✅ Running | `https://3652b2b4trial-dev-centro-medico-btp-srv.cfapps.us10-001.hana.ondemand.com` |
| `centro-medico-btp-approuter` | ✅ Running | `https://3652b2b4trial-dev-centro-medico-btp-approuter.cfapps.us10-001.hana.ondemand.com` |
| `centro-medico-btp-db-deployer` | ✅ Completado | (task, no corre permanentemente) |

## Servicios CF

| Servicio | Plan | Estado |
|----------|------|--------|
| `centro-medico-xsuaa` | application | ✅ |
| `centro-medico-hana` | hdi-shared | ✅ |
| `centro-medico-html5-repo-host` | app-host | ✅ |
| `centro-medico-html5-repo-runtime` | app-runtime | ✅ |

---

## Problema pendiente — App Fiori Not Found

**Síntoma:** Al acceder a la URL del AppRouter después del login, aparece `Not Found`.

**Log del AppRouter:**
Missing internal url for request url /adminturnosui/index.html
GET request to /adminturnosui/index.html completed with status 404

**Lo que sabemos:**
- El `xs-app.json` correcto está deployado (confirmado abriendo el `.mtar`)
- La carpeta `adminturnosui/` está dentro del `.mtar` del AppRouter (confirmado)
- El AppRouter versión 16.9.0 soporta `localDir` (confirmado en README)
- El último deploy fue `Mon 01 Jun 23:52:10` — puede que CF no haya tomado los cambios

**Próximo paso al retomar:**
```powershell
cf restage centro-medico-btp-approuter
```
Si sigue fallando, revisar si el working directory en CF es `/home/vcap/app/` y si `adminturnosui/` está ahí.

---

## Cómo correr el proyecto localmente

### Backend (terminal 1):
```powershell
cd C:\Users\marco\centro-medico-btp\srv
mvn spring-boot:run
```

### App Fiori (terminal 2):
```powershell
cd C:\Users\marco\centro-medico-btp\app\adminturnosui
npm start
```

---

## Comandos CF útiles

```powershell
# Login
cf login -a https://api.cf.us10-001.hana.ondemand.com

# Target
cf target -o 3652b2b4trial -s dev

# Ver apps
cf apps

# Ver servicios
cf services

# Logs en vivo
cf logs centro-medico-btp-approuter

# Logs recientes
cf logs centro-medico-btp-approuter --recent

# Restage (recompila droplet)
cf restage centro-medico-btp-approuter

# Variables de entorno
cf env centro-medico-btp-approuter

# Build y deploy
mbt build
cf deploy mta_archives/centro-medico-btp_1.0.0.mtar
```

---

## Datos técnicos

- **Org BTP:** `3652b2b4trial` / Space `dev` / API `https://api.cf.us10-001.hana.ondemand.com`
- **Identidad git:** Marcos Farhat / marcosfarhat@gmail.com
- **Java:** 21.0.11 SapMachine
- **Node:** 22.22.2 LTS
- **CDS:** 9.9.1
- **SAPUI5:** 1.148.1
- **Maven:** 3.9.14
- **CF CLI:** 8.18.0

---

## Cómo retomar la próxima sesión

1. Abrir nueva conversación con Claude.
2. **Pegar este documento entero** al inicio.
3. Decir: "Seguimos con la Fase 12 — el AppRouter da Not Found. Arrancamos con `cf restage`."

---

**Última actualización:** Fase 12 en progreso. srv + db + approuter deployados. Login XSUAA funcionando. Pendiente resolver Not Found en app Fiori.