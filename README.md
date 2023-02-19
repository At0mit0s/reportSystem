# Pause Menu
Követelmény: 
- esx-legacy

Menu megnyitása:
- /reports (csak adminok)

Report írása:
- /report [title] [message] | (Egy cím és egy szöveg megadásával)

Beállítások (config.lua):
> Magyar
```
Config = {}
Config.commandMember = 'report'
Config.commandAdmin = 'reports'

Config.TranslationWords = {
    title = 'Report Rendszer',
    report = {
        noReport = 'Jelenleg nincs jelentés!',
        reportBadgeTitle = 'Jelentette:',
        removeButton = 'Törlés',
        searchPlaceholder = 'Keresés [ID] vagy [Player]'
    },
    alert = {
        newReport = 'Új jelentés',
        success = "<span class='font-weight-bold font-italic text-primary'>Sikeresen</span> elküldted a jelentést!",
        solved = "A jelentés <span class='font-weight-bold font-italic text-primary'>megoldva!</span>",
        error = "A jelentés <span class='font-weight-bold font-italic' style='color: var(--error)'>el lett utasítva!</span>",
        toastAdminRemoved = "A jelentést <span class='font-weight-bold font-italic text-primary'>törölted!</span>",
        toastAdminSolved = "A jelentést <span class='font-weight-bold font-italic text-primary'>megoldottad!</span>",
        toastGoto =  "Sikeresen teleportáltál",
        toastBring =  "Sikeresen idehoztad",
        toastGotoPlayer = 'ide teleportált!',
        toastBringPlayer = 'idehozott!',
    },
}
```

> Angol
```
Config = {}
Config.commandMember = 'report'
Config.commandAdmin = 'reports'

English (angol)
Config.TranslationWords = {
    title = 'Report System',
    report = {
        noReport = 'Currently there are no reports!',
        reportBadgeTitle = 'Reported by:',
        removeButton = 'Remove',
        searchPlaceholder = 'Search [ID] or [Player]'
    },
    alert = {
        newReport = 'New report from',
        success = "<span class='font-weight-bold font-italic text-primary'>Successfully</span> sent report!",
        solved = "Report has been <span class='font-weight-bold font-italic text-primary'>solved!</span>",
        error = "Report has been <span class='font-weight-bold font-italic' style='color: var(--error)'>denied!</span>",
        toastAdminRemoved = "You have <span class='font-weight-bold font-italic text-primary'>removed</span> the report!",
        toastAdminSolved = "You have <span class='font-weight-bold font-italic text-primary'>solved</span> the report!",
        toastGoto =  "Successfully goto to",
        toastBring =  "Successfully bringed",
        toastGotoPlayer = 'has goto to you!',
        toastBringPlayer = 'has bringed you!',
    },
}
```
### Kép:
![reportSystemBanner](https://user-images.githubusercontent.com/100093093/219959811-b4dd7851-10d5-4d90-b745-5bce48406ef7.png)

### Videó:
https://streamable.com/111ra9
