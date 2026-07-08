# NgRx Concept (Angular) — Task 3

NgRx follows the same Redux pattern used by `coursesSlice.js` in this exercise: **Actions → Reducers → Selectors**, plus **Effects** for side effects like API calls.

## Data flow
```
Component → dispatch(Action) → Effect → API call → dispatch(success/failure Action) → Reducer → Store → Selector → Component
```

Reducers stay pure (no API calls, no side effects); Effects are where async work happens.

## courses.actions.ts
```ts
import { createAction, props } from '@ngrx/store';
import { Course } from '../course.service';

export const loadCourses = createAction('[Courses Page] Load Courses');
export const loadCoursesSuccess = createAction(
  '[Courses API] Load Courses Success',
  props<{ courses: Course[] }>()
);
export const loadCoursesFailure = createAction(
  '[Courses API] Load Courses Failure',
  props<{ error: string }>()
);
```

## courses.reducer.ts
```ts
import { createReducer, on } from '@ngrx/store';
import { loadCourses, loadCoursesSuccess, loadCoursesFailure } from './courses.actions';

export interface CoursesState {
  items: Course[];
  loading: boolean;
  error: string | null;
}

const initialState: CoursesState = { items: [], loading: false, error: null };

export const coursesReducer = createReducer(
  initialState,
  on(loadCourses, (state) => ({ ...state, loading: true, error: null })),
  on(loadCoursesSuccess, (state, { courses }) => ({ ...state, items: courses, loading: false })),
  on(loadCoursesFailure, (state, { error }) => ({ ...state, loading: false, error }))
);
```

## courses.effects.ts
```ts
import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { catchError, map, mergeMap, of } from 'rxjs';
import { CourseService } from '../course.service';
import { loadCourses, loadCoursesSuccess, loadCoursesFailure } from './courses.actions';

@Injectable()
export class CoursesEffects {
  loadCourses$ = createEffect(() =>
    this.actions$.pipe(
      ofType(loadCourses),
      mergeMap(() =>
        this.courseService.getCourses().pipe(
          map((courses) => loadCoursesSuccess({ courses })),
          catchError((error) => of(loadCoursesFailure({ error: error.message })))
        )
      )
    )
  );

  constructor(private actions$: Actions, private courseService: CourseService) {}
}
```

## Global error handling (Angular)
```ts
import { ErrorHandler, Injectable } from '@angular/core';

@Injectable()
export class GlobalErrorHandler implements ErrorHandler {
  handleError(error: unknown): void {
    console.error('Caught by GlobalErrorHandler:', error);
    // show a fallback UI / toast here
  }
}
// register in app.module.ts: { provide: ErrorHandler, useClass: GlobalErrorHandler }
```

---

# Framework State-Management Comparison

| | **React + Redux Toolkit** | **Angular + NgRx** | **Vue + Pinia** |
|---|---|---|---|
| Boilerplate | Low — `createSlice` + `createAsyncThunk` in one file | Highest — separate actions/reducer/effects files | Lowest — a single `defineStore` with plain functions |
| Learning curve | Moderate (thunks, selectors) | Steepest (RxJS, Actions/Reducers/Effects/Selectors) | Gentlest — feels like normal reactive JS |
| Built-in tooling | Redux DevTools (time-travel, action log) | Redux DevTools (via NgRx Store DevTools) + strong typing | Vue DevTools Pinia tab, DevTools works with almost no setup |
| Async handling | `createAsyncThunk` (Promise-based) | Effects (RxJS streams — more powerful, more concepts) | Plain `async`/`await` inside actions |
| Best fit | Teams already comfortable with Redux patterns | Large enterprise Angular apps needing strict architecture | Small-to-mid apps wanting state management with minimal ceremony |

All three follow the same underlying idea — a single source of truth updated through explicit, traceable actions — but trade off boilerplate against structure and tooling differently.
