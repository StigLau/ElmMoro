# KompostEdit Development Setup

## 🚀 Quick Start

1. **Start elm reactor** (if not running):
   ```bash
   elm reactor
   ```

2. **Compile and develop**:
   ```bash
   make dev
   ```

3. **Open in browser**: `http://localhost:8000/index.html`

## 🔧 Development Workflow

### Method 1: Using Make (Recommended)
```bash
# Compile and get ready for development
make dev

# After making changes to src/ files:
make compile
# Then refresh browser
```

### Method 2: Manual Commands
```bash
# Compile after changes
elm make src/Main.elm --output=main.js

# Then refresh http://localhost:8000/index.html
```

### Method 3: Using the Script
```bash
# Run the development script
./dev-compile.sh
```

## 🌐 Development URLs

| URL | Purpose | Notes |
|-----|---------|-------|
| `http://localhost:8000/index.html` | **Main development app** | ✅ Proper auth, multimedia works |
| `http://localhost:8000/src/Main.elm` | Raw elm reactor | ❌ Flag error (use for compilation testing) |
| `http://localhost:9002/kompostedit` | Full production app | 🔐 Requires full auth flow |

## 🔑 Authentication

The development setup uses a real Firebase auth token, so:
- ✅ Multimedia search works with real data
- ✅ API calls to backend succeed
- ✅ Full functionality available

## 📁 Project Structure

```
kompostedit/
├── src/                    # Elm source files
│   ├── Main.elm           # Main application
│   ├── Models/            # Data models
│   ├── MultimediaSearch/  # Multimedia search components
│   └── ...
├── index.html             # Development HTML with auth
├── main.js               # Compiled Elm (generated)
├── Makefile              # Development commands
├── dev-compile.sh        # Compilation script
└── DEV-SETUP.md          # This file
```

## 🔄 Development Loop

1. **Edit** Elm files in `src/`
2. **Compile** with `make dev` or `make compile`
3. **Refresh** browser at `http://localhost:8000/index.html`
4. **Test** multimedia search and other features
5. **Repeat**

## 🎵 Multimedia Search Feature

The multimedia search feature is fully implemented with a simple Bootstrap dropdown interface:

### **How it Works:**
1. **Click "Browse Multimedia"** button in the sources section
2. **Modal opens** with multimedia search interface
3. **Filter by media type** using radio buttons (All/Audio/Video)
4. **Select multimedia** from dropdown (shows "Title (mediaType)")
5. **Click "Add to Sources"** to add selected item to komposition
6. **Source appears** in "Original Sources:" section as a button

### **Technical Implementation:**
- **UI**: Simple Bootstrap dropdown replaces complex autocomplete
- **Data Flow**: Firebase DB → API → Elm dropdown → Source record
- **Integration**: Seamlessly adds multimedia as Source records to kompositions
- **Field Mapping**: title→id, duration→startingOffset, mediaType→format

### **User Benefits:**
- ✅ Easy multimedia discovery and selection
- ✅ Direct integration with existing komposition workflow  
- ✅ No complex text input - just point and click
- ✅ Real-time media type filtering

## 🐛 Troubleshooting

### Elm compilation errors
```bash
# Check syntax with elm reactor
open http://localhost:8000/src/Main.elm
```

### Blank page or errors
```bash
# Recompile and check console
make compile
# Check browser console for JavaScript errors
```

### API errors
```bash
# Ensure backend is running
cd ../kompost-mixer && npm run dev
```

### Port conflicts
```bash
# Check what's running on port 8000
lsof -i :8000
```

## 🏆 Tips

- Use `make help` to see all available commands
- Keep elm reactor running in a separate terminal
- Browser refresh is needed after each compilation
- Check browser console for useful development logs
- Use elm reactor's compilation errors for syntax debugging