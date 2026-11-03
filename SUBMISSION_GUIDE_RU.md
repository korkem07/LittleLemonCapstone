# Как сдать Little Lemon в Coursera

**Что уже готово:** код SwiftUI, проект `LittleLemon.xcodeproj`, локальный JSON, картинки, `Wireframe_Home.jpg`, описание и checklist.

**Что нельзя автоматически выполнить из этого архива:** опубликовать файлы в **твоём** GitHub и подтвердить запуск в Xcode. GitHub-ссылка появится только после публикации репозитория в твоём аккаунте.

## Публикация через GitHub на Windows или Mac

1. Создай **пустой публичный репозиторий** на github.com, например `LittleLemonCapstone` (не добавляй README на сайте).
2. Распакуй ZIP, открой терминал в папке `LittleLemonCapstone` (там, где лежит README.md).
3. Выполни:

```bash
git init
git add .
git commit -m "Complete Little Lemon iOS capstone"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/LittleLemonCapstone.git
git push -u origin main
```

Замени YOUR_USERNAME на имя аккаунта GitHub. При необходимости войди через Git Credential Manager или GitHub CLI. **Не отправляй пароль GitHub в чат.**

4. Открой GitHub и проверь, что отображаются `LittleLemon.xcodeproj`, папка `LittleLemon`, `Wireframe_Home.jpg`.
5. Coursera → My submission → Project title: `Little Lemon iOS Capstone Project` → вставь адрес своего GitHub-репозитория (без `.git` в конце).
6. Проверь два проекта из `Peers to review`.

## Тестирование

Для запуска **потребуется Mac с Xcode**. Если у тебя только Windows, код можно загрузить на GitHub, но сначала найди возможность проверить его в Xcode или iOS Simulator на Mac. Не утверждай, что запуск проверен, пока не проверишь.

## Быстрая автоматическая публикация (если установлен GitHub CLI)

На **Windows** после распаковки открой PowerShell в папке проекта и выполни:

```powershell
powershell -ExecutionPolicy Bypass -File .\PUBLISH_GITHUB_WINDOWS.ps1
```

Скрипт предложит вход в GitHub (если требуется), создаст **публичный репозиторий**, загрузит файлы и **выведет настоящую ссылку для Coursera**. Публикация происходит от твоего GitHub аккаунта, а не от ChatGPT.

На **Mac**: `bash PUBLISH_GITHUB_MAC.sh`.
