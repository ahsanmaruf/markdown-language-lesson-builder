## 📘 Obsidian Lesson Builder

A simple script to generate Obsidian-style .md files for language learning notes. It creates a folder structure based on a CSV file containing just lesson information. Folders such as `German/A1.1/grammar/01 - Personal pronouns.md`


## ✅ What It Does

	• Create structured folders from a single csv file
	• Folders are structured like this:

        - Output (e.g. German)
            - level (e.g. A1.1)
                - section (e.g. grammar)
                    - topic.md (e.g. 01 - Personal pronouns)

	• Skips files that already exist - So you can run it multiple
      times if needed to update the lesson, without worrying about 
      overwriting your notes!


## 📝 How to create lessons

01. Open lessons/topics.csv
02. Add one lesson per line like this:

```csv
level,section,topic
A1.1,grammar,Personal pronouns
A1.1,listening,Nico’s Weg 1–5
```

03. Edit Your Templates based on your needs

Current Obsidian implementation expects: 

	• {{title}}
	• {{level}}
	• {{level_tag}} (e.g. A1_1)

## 🚀 How to Run

```shell
chmod +x create_notes.sh
```
```shell
./create_notes.sh
```

und Viel Erfolg beim Sprachenlernen! 🎉
