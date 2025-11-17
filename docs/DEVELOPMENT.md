# Development Guide

## Getting Started

### Prerequisites
- Node.js 18+ and npm
- PostgreSQL 14+
- Git

### Quick Start

1. **Clone and Install**
```bash
git clone https://github.com/craigfelt/Alliance.git
cd Alliance
npm run install:all
```

2. **Setup Database**
```bash
npm run setup
```

3. **Start Development Servers**

Terminal 1 - Backend:
```bash
npm run dev:backend
```

Terminal 2 - Frontend:
```bash
npm run dev:frontend
```

4. **Access the Application**
- Frontend: http://localhost:5173
- Backend: http://localhost:5000
- Login: admin@alliance.co.za / admin123

## Project Structure

```
Alliance/
├── backend/                 # Node.js/Express backend
│   ├── src/
│   │   ├── config/         # Configuration files
│   │   ├── controllers/    # Route controllers
│   │   ├── middleware/     # Express middleware
│   │   ├── models/         # Database models
│   │   ├── routes/         # API routes
│   │   ├── services/       # Business logic
│   │   └── server.js       # Entry point
│   ├── .env                # Environment variables
│   └── package.json
├── frontend/               # React frontend
│   ├── src/
│   │   ├── components/     # Reusable components
│   │   ├── context/        # React context
│   │   ├── pages/          # Page components
│   │   ├── services/       # API services
│   │   ├── utils/          # Utility functions
│   │   └── App.jsx         # Main app component
│   ├── .env                # Environment variables
│   └── package.json
├── database/               # Database schemas and migrations
│   ├── schema.sql          # Initial schema
│   └── setup.sh            # Setup script
└── docs/                   # Documentation
```

## Backend Development

### API Routes

```javascript
// Auth
POST   /api/auth/register
POST   /api/auth/login
GET    /api/auth/me
PUT    /api/auth/update-password

// Properties
GET    /api/properties
GET    /api/properties/:id
POST   /api/properties
PUT    /api/properties/:id
DELETE /api/properties/:id

// Tenants
GET    /api/tenants
GET    /api/tenants/:id
POST   /api/tenants
PUT    /api/tenants/:id
DELETE /api/tenants/:id

// Leases
GET    /api/leases
GET    /api/leases/:id
POST   /api/leases
PUT    /api/leases/:id
DELETE /api/leases/:id
POST   /api/leases/:id/renew

// Financial
GET    /api/financial/invoices
POST   /api/financial/invoices
GET    /api/financial/payments
POST   /api/financial/payments
GET    /api/financial/trust-accounts

// Maintenance
GET    /api/maintenance
POST   /api/maintenance
PUT    /api/maintenance/:id

// Reports
GET    /api/reports/financial?startDate=&endDate=
GET    /api/reports/occupancy
GET    /api/reports/arrears

// Dashboard
GET    /api/dashboard/stats
```

### Adding a New Feature

1. **Create route** in `backend/src/routes/`
2. **Create controller** in `backend/src/controllers/`
3. **Update database** if needed
4. **Add service** in `frontend/src/services/`
5. **Create page/component** in `frontend/src/pages/` or `frontend/src/components/`
6. **Add to navigation** in `frontend/src/components/Layout.jsx`

### Environment Variables

Backend (`.env`):
```
PORT=5000
NODE_ENV=development
JWT_SECRET=your-secret-key
JWT_EXPIRE=7d
DB_HOST=localhost
DB_PORT=5432
DB_NAME=alliance_property
DB_USER=postgres
DB_PASSWORD=postgres
CORS_ORIGIN=http://localhost:5173
```

Frontend (`.env`):
```
VITE_API_URL=http://localhost:5000/api
```

## Frontend Development

### Component Structure

```jsx
// Functional component with hooks
import { useState, useEffect } from 'react';

export default function MyComponent() {
  const [data, setData] = useState([]);
  
  useEffect(() => {
    loadData();
  }, []);
  
  const loadData = async () => {
    // API call
  };
  
  return (
    <div>
      {/* JSX */}
    </div>
  );
}
```

### Styling with Tailwind

```jsx
// Use Tailwind utility classes
<div className="bg-white rounded-xl shadow-sm p-6">
  <h1 className="text-3xl font-bold text-gray-900">Title</h1>
  <p className="text-gray-600 mt-2">Description</p>
</div>
```

### API Calls

```javascript
import { propertyService } from '../services';

const properties = await propertyService.getAll({ page: 1, limit: 10 });
```

## Database

### Running Migrations

```bash
psql alliance_property < database/schema.sql
```

### Adding a New Table

1. Add table definition to `database/schema.sql`
2. Create migration file if needed
3. Update backend models/controllers
4. Update frontend services

## Testing

### Backend Testing
```bash
cd backend
npm test
```

### Frontend Testing
```bash
cd frontend
npm test
```

## Building for Production

### Backend
```bash
cd backend
npm start
```

### Frontend
```bash
cd frontend
npm run build
npm run preview
```

## Common Tasks

### Add New User
```sql
INSERT INTO users (email, password, first_name, last_name, role)
VALUES ('user@example.com', '$2a$10$hash...', 'First', 'Last', 'user');
```

### Reset Password (in psql)
```sql
UPDATE users 
SET password = '$2a$10$YQhE3r0Z9h8GvVJKxNqXM.WkHxNfXqYgL5bXz9X2xrMQ8XzxX0X0K'
WHERE email = 'admin@alliance.co.za';
-- Password is: admin123
```

### View Database Stats
```sql
SELECT 
  (SELECT COUNT(*) FROM properties) as properties,
  (SELECT COUNT(*) FROM tenants) as tenants,
  (SELECT COUNT(*) FROM leases WHERE status = 'active') as active_leases;
```

## Troubleshooting

### Backend won't start
- Check PostgreSQL is running: `pg_isready`
- Verify database exists: `psql -l`
- Check environment variables in `.env`

### Frontend can't connect to API
- Verify backend is running on port 5000
- Check CORS settings in backend
- Verify `VITE_API_URL` in frontend `.env`

### Database connection issues
- Check credentials in backend `.env`
- Ensure PostgreSQL is accepting connections
- Verify firewall settings

## Code Style

### JavaScript/React
- Use functional components
- Use hooks for state management
- ES6+ syntax
- Async/await for promises
- Descriptive variable names

### Database
- Snake_case for column names
- Plural table names
- Foreign keys: `table_id`
- Always use transactions for multi-table operations

## Best Practices

1. **Security**
   - Never commit `.env` files
   - Use parameterized queries
   - Validate all inputs
   - Use HTTPS in production

2. **Performance**
   - Index foreign keys
   - Paginate large datasets
   - Cache frequent queries
   - Optimize images

3. **Code Quality**
   - Write meaningful comments
   - Keep functions small
   - Use error handling
   - Follow DRY principle

## Resources

- [React Documentation](https://react.dev)
- [Express.js Guide](https://expressjs.com)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Tailwind CSS](https://tailwindcss.com)

## Getting Help

- Check documentation in `/docs`
- Review existing code examples
- Search issues on GitHub
- Contact: dev-team@alliance.co.za
