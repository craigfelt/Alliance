# Alliance Property Management - Copilot Instructions

## Project Overview
Full-stack commercial property management system for Alliance Property Group (Durban, South Africa), replacing legacy MDA Property Manager. Built with React/Vite frontend, Node.js/Express backend, and PostgreSQL database.

## Architecture

### Monorepo Structure
- `backend/` - Express API with ES modules (`"type": "module"`)
- `frontend/` - React 19 + Vite with TailwindCSS
- `database/` - PostgreSQL schema with SA-specific compliance features
- Root `package.json` has workspace scripts (`npm run dev:backend`, `npm run dev:frontend`)

### Key Architectural Decisions

**Database-First Design**: PostgreSQL schema (`database/schema.sql`) is the source of truth. All 11 tables use `SERIAL` primary keys and enforce referential integrity via CASCADE constraints.

**Response Format Pattern**: All API endpoints return standardized JSON:
```javascript
{ success: true, data: {...} }  // Success
{ success: false, message: "..." }  // Error
```

**Authentication Flow**: JWT tokens stored in `localStorage`, injected via axios interceptors (`frontend/src/services/api.js`). Middleware in `backend/src/middleware/auth.js` expects `Bearer <token>` format.

**South African Compliance**: 
- Trust accounts table for FPSA compliance
- ZAR currency formatting via `formatCurrency()` helper
- Property types: `office | retail | industrial | warehouse | mixed-use`
- VAT number storage for commercial tenants

## Development Workflows

### Running Locally (Two Terminals Required)
```bash
# Terminal 1 - Backend (Port 5000)
cd backend
npm run dev  # Uses nodemon

# Terminal 2 - Frontend (Port 5173)
cd frontend
npm run dev  # Vite HMR
```

### Database Setup
```bash
# Create database
createdb alliance_property

# Run schema (includes sample data)
psql alliance_property < database/schema.sql
```

**Default credentials**: `admin@alliance.co.za` / `admin123` (created by schema)

### Environment Configuration
**Backend** (`backend/.env`):
- `JWT_SECRET` - Required for authentication
- `DB_*` variables - PostgreSQL connection
- `CORS_ORIGIN` - Frontend URL (default: `http://localhost:5173`)

**Frontend** (`frontend/.env`):
- `VITE_API_URL` - Backend URL (default: `http://localhost:5000/api`)

## Code Patterns & Conventions

### Backend Controllers
All controllers follow this pattern (see `backend/src/controllers/propertyController.js`):
```javascript
export const getProperties = async (req, res, next) => {
  try {
    // Parse query params: { page, limit, search }
    // Use parameterized queries: pool.query(sql, [params])
    // Include pagination metadata in response
    res.json({ success: true, data: results, pagination: {...} });
  } catch (error) {
    next(error);  // Always pass to error middleware
  }
};
```

**Critical**: Use `pool.query()` from `backend/src/config/database.js`, never create new pool instances.

### Route Protection
All API routes except `/api/auth/*` require `protect` middleware:
```javascript
import { protect, authorize } from '../middleware/auth.js';
router.use(protect);  // Apply to all routes
router.delete('/:id', authorize('admin'), deleteProperty);  // Role-based
```

### Frontend Service Layer
Services (`frontend/src/services/`) wrap API calls and extract `.data`:
```javascript
export const propertyService = {
  getAll: async (params) => {
    const response = await api.get('/properties', { params });
    return response.data;  // Returns { success, data, pagination }
  },
};
```

### React Component Structure
Pages use this loading pattern (see `frontend/src/pages/Dashboard.jsx`):
```javascript
const [data, setData] = useState(null);
const [loading, setLoading] = useState(true);

useEffect(() => {
  loadData().finally(() => setLoading(false));
}, []);

if (loading) return <div className="animate-spin..." />;
if (!data) return <div>Failed to load</div>;
```

## Database Queries

### Aggregation Pattern
Dashboard queries use PostgreSQL `FILTER` for conditional counting:
```sql
SELECT 
  COUNT(*) as total,
  COUNT(*) FILTER (WHERE status = 'occupied') as occupied
FROM units
```

### Property-Unit Relationship
Properties have many units (1:N). Always join for occupancy data:
```sql
SELECT p.*, 
  COUNT(u.id) FILTER (WHERE u.status = 'occupied') as occupied_units,
  COUNT(u.id) as total_units
FROM properties p
LEFT JOIN units u ON u.property_id = p.id
GROUP BY p.id
```

### Lease-Invoice-Payment Chain
Financial tracking follows: `leases -> invoices -> payments` (see `database/schema.sql` foreign keys)

## Critical Integration Points

### Auth Context (`frontend/src/context/AuthContext.jsx`)
Global auth state. Components access via `useAuth()` hook:
```javascript
const { user, login, logout, isAuthenticated } = useAuth();
```

**Token refresh**: Not implemented. Tokens expire after 7 days (JWT config).

### Protected Routes
`frontend/src/components/ProtectedRoute.jsx` checks `isAuthenticated` before rendering. Redirects to `/login` if false.

### Axios Interceptors
Auto-injects token and handles 401 (auto-logout) in `frontend/src/services/api.js`.

## MDA Migration Context

System designed to import legacy MDA Property Manager data. Key points:
- Field mappings documented in `docs/MDA_MIGRATION.md`
- Migration service at `backend/src/services/migration.js`
- API endpoint: `POST /api/migration/import`
- Schema accommodates historical data (e.g., expired leases, past transactions)

## Project-Specific Quirks

1. **ES Modules Everywhere**: All backend files use `.js` extensions but are ES modules (`import/export`, not `require`). Package.json has `"type": "module"`.

2. **Tailwind Merge Pattern**: Use `clsx` + `tailwind-merge` for conditional classes (not in all components yet, but preferred).

3. **South African Formatting**: 
   - Dates: `new Date().toLocaleDateString('en-ZA')` (DD/MM/YYYY)
   - Currency: `formatCurrency()` helper adds "R" prefix

4. **No TypeScript**: Project uses JavaScript with JSDoc comments in places. Maintain this pattern.

5. **Nodemon for Backend**: Dev mode uses `nodemon` (auto-restart on file changes). Production uses `node src/server.js`.

## Common Tasks

**Add New API Endpoint**:
1. Create controller function in `backend/src/controllers/`
2. Add route in `backend/src/routes/`
3. Import route in `backend/src/server.js`
4. Add service method in `frontend/src/services/`

**Add New Page**:
1. Create component in `frontend/src/pages/`
2. Add route in `frontend/src/App.jsx`
3. Update sidebar in `frontend/src/components/Layout.jsx`

**Database Schema Changes**:
1. Update `database/schema.sql`
2. Re-run schema (drops all tables via CASCADE)
3. Update TypeScript/JSDoc types if documented

## Testing Status
- No automated tests currently
- Manual testing via UI and Postman
- `TEST_RESULTS.md` documents manual test outcomes

## Documentation
- `README.md` - User-facing setup guide
- `docs/DEVELOPMENT.md` - Detailed API reference
- `docs/MDA_MIGRATION.md` - Legacy migration process
- `COPILOT_WORKFLOW.md` - GitHub Copilot Agent workflow (PR syncing)
