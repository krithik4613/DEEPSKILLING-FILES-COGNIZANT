# Hands-On 7 — Angular: Components, Services, DI, Routing & Forms

**Level:** Advanced
**Stack:** Angular 17 (Angular CLI project)

## What this covers
- Components generated via Angular CLI: `header`, `course-list`, `course-card`, `student-profile`
- Data binding: interpolation `{{ }}`, property binding `[input]`, two-way binding `[(ngModel)]`, `*ngFor`, `*ngIf`
- `CourseService` — a singleton (`providedIn: 'root'`) that wraps `HttpClient` and fetches data from JSONPlaceholder
- Dependency injection of `CourseService` into `CourseListComponent`
- `app-routing.module.ts` — routes for `/` (course list) and `/profile` (reactive form)
- Reactive Forms: `FormGroup`, `FormControl`, `Validators`, inline validation messages, disabled submit until valid
- Keyboard accessibility on course cards (`tabindex`, `(keydown.enter)`) and `aria-live` search result counts, in line with the Hands-On 9 accessibility pass

## Project structure
```
handson_07/
├── package.json
└── src/
    ├── index.html
    ├── main.ts
    ├── styles.css
    └── app/
        ├── app.module.ts
        ├── app-routing.module.ts
        ├── app.component.ts / .html
        ├── course.service.ts
        ├── header/
        ├── course-list/
        ├── course-card/
        └── student-profile/
```
> `node_modules/` is excluded — install fresh with the commands below.

## How to run
```bash
npm install -g @angular/cli   # if not already installed
npm install
ng serve
```
Visit `http://localhost:4200`.

## Try it
- The course list loads from JSONPlaceholder via `CourseService` — a brief "Loading courses..." message appears first.
- Type in the search box → cards filter live via `[(ngModel)]`.
- Navigate to `/profile` → fill the form; the **Submit** button stays disabled until name, a valid email, and a semester (1–8) are all provided. Invalid, touched fields show inline error text.
