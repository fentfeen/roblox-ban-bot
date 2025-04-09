# Roblox Moderation System (with Trello & Discord Integration)

This is a moderation system for Roblox games that supports Trello integration for ban management and optional Discord bot control. Admins can ban/kick players in-game using chat commands or through Discord.

(note: this hasnt been tested in a long time)

---

## 📁 Folder Structure (Roblox Studio)

Place the following inside **`ServerScriptService`**:

```
📁 ServerScriptService
└── 📁 ModerationSystem
    ├── 📄 Moderation           -- Script (main moderation logic)
    ├── 📄 CommandModule        -- ModuleScript (kick/ban command functions)
    ├── 📄 TrelloModule         -- ModuleScript (Trello API handler)
    ├── 🔑 Key                  -- StringValue (Trello API Key)
    ├── 🔑 Secret               -- StringValue (Trello API Token)
```

> Ensure that `Key` and `Secret` are children of the `TrelloModule` ModuleScript.

---

## 🔧 Setup Instructions

### 1. Trello Setup

1. Create a Trello board for bans.
2. Make a **list** on the board (e.g., "Banned Players").
3. Copy the **List ID** (found in the URL or via Trello API).
4. Create a **Trello API Key** and **Token** here: [https://trello.com/app-key](https://trello.com/app-key).

Update the following in `TrelloModule.lua`:

```lua
trello.BanListId = 'YOUR_LIST_ID_HERE'
```

---

### 2. Roblox Setup

1. In Roblox Studio, set up the folder structure as above.
2. In `TrelloModule`, insert two StringValues:
   - `Key` → Paste your Trello API Key
   - `Secret` → Paste your Trello Token
3. Add your admin UserIds in `moderation.lua`:

```lua
local admins = {
    [12345678] = true, -- Replace with actual Roblox UserId
}
```

---

### 3. Chat Commands (in-game)

Admins can use these commands in chat:

- `/kick <username> [reason]`  
  Kicks the player from the server.

- `/ban <username> <days> [reason]`  
  Bans the player by adding their UserId to the Trello list.

---

### 4. Automatic Ban Checks

- When a player joins, the system checks the Trello list for their ban status.
- If the ban is expired or not found, they can join.
- Ban checks repeat every 30 seconds for active players.

---

## 🤖 Optional: Discord Bot Setup

1. Use the provided Python bot (`ban code.txt`).
2. Install dependencies:

```
pip install discord.py pyblox3 py-trello
```

3. Fill in the placeholders in the script:
   - Trello API key/token
   - Discord bot token
   - Trello ban list ID

4. Run the bot:

```
python bot.py
```

### Discord Command:

```
/gban <username or userId>
```

Adds the specified user to the Trello ban list.

---
