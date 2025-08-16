# 📘 AFFM MCP Development Roadmap

## 🎯 Goal

Develop a local AI-powered AFFM system for generating and editing financial product UI JSONs using the MCP Python SDK, with support for reverse prompting, schema validation, CRUD editing, and LLM integration via Ollama.

---

## 🛠️ Stage 1: Environment Setup

### ✅ 1.1 System Requirements

- macOS (M2 or higher)
- Python 3.10+
- Node.js (optional for frontend)
- Ollama (for local LLMs)

### ✅ 1.2 Backend Setup

```bash
# Create and activate virtualenv
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install uvicorn
```

### ✅ 1.3 MCP SDK Setup

```bash
pip install modelcontextprotocol

# Or clone for local development
git clone https://github.com/modelcontextprotocol/python-sdk
```

### ✅ 1.4 Ollama + LLM Setup

```bash
brew install ollama
ollama run mistral         # Or phi3, llama3
```

---

## 🧱 Stage 2: Project Structure

```bash
affm-mcp/
├── app/                   # Backend code
│   ├── main.py
│   ├── api/
│   ├── services/
│   ├── mcp/
│   ├── db/
│   ├── schemas/
│   └── utils/
├── data/                  # Templates & Components
│   ├── journeys/
│   ├── templates/
│   ├── components/
│   └── schema/
└── tests/
```

---

## 🔄 Stage 3: Core Functionalities

### ✅ 3.1 Reverse Prompting Wizard

- Ask for journey and role
- Collect applicable stages
- Ask for screens under each stage
- Choose template type per screen
- Prompt for fields/tables as needed

> 📄 Implement in: `services/conversation.py`

---

### ✅ 3.2 JSON Generator

- Combines selected templates and components
- Assembles full `stage_screen_map`

> 📄 Implement in: `services/generator.py`, `mcp/tools/tool_generate.py`

---

### ✅ 3.3 JSON Editor

- Supports:
  - Freeform instruction using LLM
  - Manual CRUD operations (add/remove/update)
- Tracks edit history and triggers re-validation

> 📄 Implement in: `services/edit.py`, `services/crud.py`

---

### ✅ 3.4 Schema Validation

- Validates against:
  - Overall journey schema
  - Per-template schemas

> 📄 Implement in: `services/validate.py`, `mcp/tools/tool_validate.py`

---

### ✅ 3.5 Persistence

- Autosave draft JSONs
- Export final JSON to file
- Store history in SQLite

> 📄 Implement in: `db/session_db.py`

---

### ✅ 3.6 FastAPI Endpoints

```http
POST /generate-json
POST /edit-json
POST /validate-json
POST /save-final
```

> 📄 Implement in: `api/routes_*.py`

---

## 🤖 Stage 4: MCP SDK Integration

### ✅ MCP Tools

```bash
affm-mcp/app/mcp/tools/
├── tool_generate.py
├── tool_edit.py
├── tool_validate.py
```

### ✅ MCP Resources

```bash
affm-mcp/app/mcp/resources/
├── templates/
├── components/
└── schema/
```

### ✅ MCP Prompts

- Use structured prompts combining:
  - Template JSON
  - Component examples
  - User instructions
- Validate LLM output strictly

---

## 🧪 Stage 5: Testing & Debugging

### ✅ CLI Tester

```bash
python cli_mode_selector.py
```

- Simulate wizard steps
- Log all prompt/response data

### ✅ Error Logging

- Track:
  - Failed JSON validation
  - Raw LLM responses
  - Instruction + output history

---

## 💻 Stage 6: UI Integration (Optional)

- Use Angular/React to:
  - Call MCP APIs
  - Render JSON as UI
  - Allow interactive prompt-driven edits

> Integrate `/generate-json`, `/edit-json`, and `/validate-json`

---

## 📅 Milestones

| Week | Deliverables |
|------|--------------|
| Week 1 | ✅ Environment setup<br>✅ MCP SDK<br>✅ Folder scaffolding |
| Week 2 | ✅ Reverse prompting wizard<br>✅ JSON generator |
| Week 3 | ✅ CRUD & LLM editing<br>✅ Schema validation<br>✅ Save/export |
| Week 4 | ✅ Final API polish<br>✅ CLI tester<br>✅ (Optional) UI binding |

---

## 🌟 Bonus (Post-v1 Ideas)

- Role-based access + saved sessions
- Function-calling LLM support
- Custom training or embeddings
- LangChain/LlamaIndex orchestration

---

## ✅ Final Output

- Fully working AFFM MCP backend
- JSON generation/editing + validation
- CLI and API modes
- SQLite + file export
- LLM integration via Ollama
