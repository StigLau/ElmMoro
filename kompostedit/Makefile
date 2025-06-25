# KompostEdit Development Makefile

.PHONY: dev compile serve clean help frontend-killer

# Default target
dev: compile
	@echo "🚀 Development build complete!"
	@echo "📱 Open: http://localhost:8000/index.html"
	@echo "⚡ Elm reactor should be running for live serving"

# Compile Elm to JavaScript
compile:
	@echo "🔨 Compiling Elm application..."
	elm make src/Main.elm --output=main.js

# Start elm reactor (if not running)
serve:
	@echo "⚡ Starting elm reactor..."
	elm reactor

# Start both backend and elm reactor
full-dev:
	@echo "🔧 Starting full development environment..."
	@echo "🚀 Starting Next.js backend..."
	cd ../kompost-mixer && npm run dev &
	@echo "⚡ Starting elm reactor..."
	elm reactor

# Clean compiled files
clean:
	@echo "🧹 Cleaning compiled files..."
	rm -f main.js
	rm -rf elm-stuff/generated-code

# Kill frontend processes
frontend-killer:
	@echo "🔪 Killing frontend processes..."
	@echo "Stopping elm reactor processes..."
	-pkill -f "elm reactor" || true
	@echo "Stopping npm/node processes..."
	-pkill -f "npm run dev" || true
	-pkill -f "next dev" || true
	@echo "Stopping any processes on port 8000..."
	-lsof -ti:8000 | xargs kill -9 2>/dev/null || true
	@echo "Stopping any processes on port 9002..."
	-lsof -ti:9002 | xargs kill -9 2>/dev/null || true
	@echo "✅ Frontend processes killed"

# Development workflow
watch:
	@echo "👀 Watching for changes..."
	@echo "💡 Edit files in src/, then run 'make compile' and refresh browser"
	@echo "🔄 Or run 'make dev' after each change"

# Show help
help:
	@echo "KompostEdit Development Commands:"
	@echo ""
	@echo "  make dev             - Compile Elm app (default)"
	@echo "  make compile         - Compile Elm to JavaScript"
	@echo "  make serve           - Start elm reactor"
	@echo "  make full-dev        - Start backend + elm reactor"
	@echo "  make frontend-killer - Kill all frontend processes"
	@echo "  make clean           - Remove compiled files"
	@echo "  make watch           - Show development workflow tips"
	@echo "  make help            - Show this help"
	@echo ""
	@echo "Development URLs:"
	@echo "  http://localhost:8000/index.html     - Main development app"
	@echo "  http://localhost:8000/src/Main.elm   - Raw elm reactor (flag error)"
	@echo "  http://localhost:9002/kompostedit    - Full auth app"