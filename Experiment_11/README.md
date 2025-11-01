# Experiment 11: Fetch data from PublicRest API and display results in the app

---

## Aim
Build a mobile app that fetches wallpapers from a **Public REST API** (Pexels API), parses JSON into app models, and displays them in a scrollable grid with **loaded, empty, and error states**. The app also allows users to view wallpapers in **full-screen mode**.

---

## Materials / Tools Used
- **Flutter SDK**
- **Dart Programming Language**
- **Pexels API** (Free API key)
- **Visual Studio Code / Android Studio**
- Dependencies:
    - `http` for REST API calls
    - `cached_network_image` for image caching

---

## Steps Followed

1. **API Setup**
    - Created a free account on [Pexels API](https://www.pexels.com/api/).
    - Generated a personal **API key**.

2. **Project Setup**
    - Created a new Flutter project.
    - Installed required dependencies:
      ```bash
      flutter pub get
      ```

3. **Folder Structure**
    - `models/` → defines `Wallpaper` model
    - `services/` → `ApiClient` handles API requests
    - `repository/` → `WallpaperRepository` separates data access
    - `viewmodel/` → `WallpaperViewModel` handles state
    - `screens/` → `WallpaperScreen` displays wallpapers
    - `main.dart` → app entry point

4. **Model Creation**
    - Created `Wallpaper` class to store wallpaper data (photographer, thumbnail URL, full image URL).

5. **API Client**
    - Used HTTP GET request to fetch wallpapers.
    - Included API key in request headers for authentication.

6. **Repository Layer**
    - Created `WallpaperRepository` to fetch data from API client.

7. **ViewModel**
    - Managed app states:
        - `loading`
        - `loaded`
        - `empty`
        - `error`

8. **UI Design**
    - Displayed wallpapers in a **scrollable grid view**.
    - Added **pull-to-refresh**.
    - Tap to view **full-screen image**.
    - Showed **loading spinner**, **empty state message**, or **error message** based on app state.

9. **Testing**
    - Tested API responses and app functionality.
    - Ensured app displays wallpapers correctly for valid API key.

---

## Expected Output

- **Loading State:** Circular spinner shown while fetching wallpapers.
- **Loaded State:** Wallpapers displayed in a **grid view** with images loaded via `cached_network_image`.
- **Empty State:** Message “No wallpapers found 😕” if API returns no results.
- **Error State:** Message with retry button if fetching fails (e.g., wrong API key, network error).
- **Full-screen View:** Tap any wallpaper to view it in full resolution.