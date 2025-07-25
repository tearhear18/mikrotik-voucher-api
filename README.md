# MikroTik Piso WiFi Dashboard

A modern, clean, and maintainable Ruby on Rails application for managing MikroTik routers, hotspot profiles, stations, and vouchers with a beautiful AdminLTE interface.

## ✨ Features

### 🔧 **Router Management**
- Connect to multiple MikroTik routers
- Fetch and display router information
- Monitor router status and configuration

### 📡 **Station Management**
- Create and manage WiFi stations
- Track station performance and statistics
- Commission-based earning calculations

### 🎫 **Voucher System**
- Generate vouchers with customizable codes
- Support for hotspot profiles with rate limits
- Bulk voucher creation
- Real-time voucher status tracking (collected/available)
- Background job processing for voucher creation

### 📊 **Analytics & Reporting**
- Interactive charts and graphs
- Daily/weekly/monthly sales reports
- Login statistics and user activity tracking
- Commission calculations per station

### 👤 **User Management**
- Secure authentication system
- Role-based access control
- User-specific data isolation

## 🚀 **Recent Refactoring Improvements**

### **Backend Architecture**
- ✅ **Service Objects**: Business logic moved from controllers to dedicated service classes
- ✅ **Clean Controllers**: Thin controllers focused only on HTTP concerns
- ✅ **Enhanced Models**: Proper validations, scopes, and relationships
- ✅ **RESTful Routes**: Organized and conventional routing structure
- ✅ **Error Handling**: Comprehensive error handling and validation

### **Frontend & UI**
- ✅ **AdminLTE 3**: Modern, responsive admin dashboard
- ✅ **Consistent Styling**: Uniform design patterns across all views
- ✅ **Interactive Components**: Cards, charts, tables, and forms
- ✅ **Mobile Responsive**: Works perfectly on all device sizes
- ✅ **User Experience**: Intuitive navigation and clear feedback

### **Code Quality**
- ✅ **DRY Principles**: Removed code duplication
- ✅ **Maintainable Code**: Clear structure and naming conventions
- ✅ **Separation of Concerns**: Each class has a single responsibility
- ✅ **Documentation**: Comprehensive comments and documentation

## 🛠 **Technology Stack**

- **Backend**: Ruby on Rails 8.0
- **Database**: PostgreSQL
- **Frontend**: AdminLTE 3, Bootstrap 4.6, FontAwesome
- **Charts**: Chart.js via Chartkick
- **Authentication**: Custom secure authentication
- **Background Jobs**: Solid Queue
- **Pagination**: Kaminari
- **Development**: Docker support included

## 📋 **Prerequisites**

- Ruby 3.2+
- Rails 8.0+
- PostgreSQL 12+
- Node.js 18+ (for asset compilation)

## 🔧 **Installation & Setup**

### **1. Clone the Repository**
```bash
git clone <repository-url>
cd mikrotik-api
```

### **2. Install Dependencies**
```bash
bundle install
```

### **3. Database Setup**
```bash
rails db:create
rails db:migrate
rails db:seed
```

### **4. Environment Configuration**
Create a `.env` file or configure environment variables:
```bash
# Database
DATABASE_URL=postgresql://username:password@localhost/mikrotik_api_development

# Application
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_here
```

### **5. Start the Application**
```bash
rails server
```

Visit `http://localhost:3000` to access the application.

## 🏗 **Application Structure**

### **Controllers**
```
app/controllers/
├── api/v1/                    # API endpoints
├── concerns/                  # Shared controller logic
├── dashboard_controller.rb    # Main dashboard
├── routers_controller.rb      # Router management
├── stations_controller.rb     # Station management
├── vouchers_controller.rb     # Voucher operations
└── ...
```

### **Models**
```
app/models/
├── router.rb                  # Router entity with validations
├── station.rb                 # Station with commission logic
├── voucher.rb                 # Voucher with status tracking
├── hotspot_profile.rb         # Rate limit profiles
└── ...
```

### **Services**
```
app/service/
├── voucher_service.rb         # Voucher creation & processing
├── router_configuration_service.rb  # Router API interactions
├── mikrotik_service.rb        # MikroTik API wrapper
└── statistics_service.rb      # Analytics calculations
```

### **Views (AdminLTE)**
```
app/views/
├── layouts/application.html.erb    # Main layout with AdminLTE
├── shared/                         # Reusable components
│   ├── _header.html.erb           # Navigation header
│   ├── _sidemenu.html.erb         # Sidebar navigation
│   └── _footer.html.erb           # Footer
├── dashboard/                      # Dashboard views
├── routers/                        # Router management
├── stations/                       # Station views
└── vouchers/                       # Voucher management
```

## 📖 **Usage Guide**

### **1. Initial Setup**
1. Create your first user account
2. Add a MikroTik router with connection details
3. Create stations under your router
4. Set up hotspot profiles for different rate limits

### **2. Voucher Management**
1. Navigate to a station
2. Choose a hotspot profile
3. Generate vouchers in bulk
4. Monitor voucher status and collection

### **3. Analytics**
- View dashboard for overview statistics
- Check individual station performance
- Monitor daily/weekly sales trends
- Track commission earnings

## 🔌 **API Endpoints**

### **Authentication Required**
- `GET /api/v1/vouchers/:code` - Get voucher details
- `POST /api/v1/vouchers` - Create voucher
- `POST /api/v1/vouchers/process` - Process voucher code

### **Example API Usage**
```bash
# Get voucher information
curl -X GET "http://localhost:3000/api/v1/vouchers/STATION-ABC123"

# Process a voucher
curl -X POST "http://localhost:3000/api/v1/vouchers/process" \
  -H "Content-Type: application/json" \
  -d '{"code": "STATION-ABC123"}'
```

## 🧪 **Testing**

Run the test suite:
```bash
# RSpec tests
bundle exec rspec

# System tests
bundle exec rspec spec/system/

# Controller tests
bundle exec rspec spec/controllers/
```

## 🚀 **Deployment**

### **Docker Deployment**
```bash
# Build image
docker build -t mikrotik-dashboard .

# Run container
docker run -p 3000:3000 mikrotik-dashboard
```

### **Kamal Deployment**
```bash
kamal setup
kamal deploy
```

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes following the established patterns
4. Write/update tests for your changes
5. Submit a pull request

### **Code Style Guidelines**
- Follow Rails conventions and best practices
- Use service objects for complex business logic
- Keep controllers thin and focused
- Write comprehensive tests
- Document significant changes

## 📝 **License**

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🆘 **Support**

- **Documentation**: Check this README and code comments
- **Issues**: Create an issue on the repository
- **Development**: Follow the established patterns and service structure

## 🎯 **Future Enhancements**

- [ ] Real-time notifications
- [ ] Advanced reporting and analytics
- [ ] Multi-language support
- [ ] Enhanced MikroTik API integration
- [ ] Mobile app companion
- [ ] Advanced user role management

---

**Built with ❤️ using Ruby on Rails and AdminLTE**
