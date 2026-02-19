# Test Coverage Analysis

## Current State

The codebase uses two test frameworks side-by-side: **Minitest** (in `test/`) and **RSpec** (in `spec/`). RSpec is the primary active framework. There is **no code coverage tool** (e.g., SimpleCov) configured.

### Existing Test Inventory

| Area | File | Status |
|------|------|--------|
| Home model validations | `spec/models/home_spec.rb` | Has tests |
| Home model image handling | `spec/models/home_spec.rb` | Has tests |
| User model | `test/models/user_test.rb` | **Empty placeholder** |
| Favorite model | `test/models/favorite_test.rb` | **Empty placeholder** |
| Home model (Minitest) | `test/models/home_test.rb` | **Empty placeholder** |
| Homes CRUD requests | `spec/requests/homes_spec.rb` | Has tests |
| Homes index view | `spec/views/homes/index.html.erb_spec.rb` | Has tests |
| Homes show view | `spec/views/homes/show.html.erb_spec.rb` | Has tests |
| Homes new view | `spec/views/homes/new.html.erb_spec.rb` | Has tests |
| Homes edit view | `spec/views/homes/edit.html.erb_spec.rb` | Has tests |
| Pages controller | `test/controllers/pages_controller_test.rb` | Has 1 test |
| Sessions controller | `test/controllers/sessions_controller_test.rb` | **Empty placeholder** |
| Homes controller (Minitest) | `test/controllers/homes_controller_test.rb` | Has tests |
| Notifications mailer | `test/mailers/notifications_mailer_test.rb` | Has tests (broken) |
| Shrine rake tasks | `spec/lib/tasks/shrine_rake_spec.rb` | **Empty placeholder** |

---

## Coverage Gaps (Ordered by Priority)

### 1. User Model — No Tests at All

**File:** `app/models/user.rb`
**Risk: HIGH**

The `User` model has zero RSpec coverage. The Minitest file `test/models/user_test.rb` is an empty placeholder. The `User.from_omniauth` class method is the sole authentication entry point for the entire application and is completely untested.

**What to test:**
- `User.from_omniauth` creates a new user when none exists for the given provider/uid
- `User.from_omniauth` finds and updates an existing user on repeat login
- `User.from_omniauth` correctly maps `name`, `nickname`, and `access_token` from OmniAuth data
- `User.from_omniauth` calls `save!` (raises on validation failure)
- Edge cases: nil/missing fields in OmniAuth data

### 2. Favorite Model — No Tests at All

**File:** `app/models/favorite.rb`
**Risk: HIGH**

The `Favorite` model has zero test coverage. The Minitest file is an empty placeholder and no RSpec spec exists. There is also no FactoryBot factory for `Favorite`.

**What to test:**
- `belongs_to :home` and `belongs_to :user` associations
- Creating a valid favorite
- Uniqueness constraint (should a user be able to favorite the same home twice?)
- Cascading deletion behavior (what happens to favorites when a home or user is deleted?)

### 3. Session Controller — No Tests at All

**File:** `app/controllers/session_controller.rb`
**Risk: HIGH**

The `SessionsController` handles login, logout, and OmniAuth callback. The Minitest file `test/controllers/sessions_controller_test.rb` is an empty placeholder. No RSpec request spec exists.

**What to test:**
- `GET /login` renders the login page
- `POST /login` (OmniAuth callback) sets the session and redirects
- `GET /logout` clears the session and redirects to homes path
- `GET /auth/failure` handles OAuth failures
- Bug: `session#create` calls `NotificationsMailer.signup(@user)` but `@user` is never assigned — it should be `current_user` or a local variable. This would raise a `NoMethodError` in production.

### 4. Authentication & Authorization Logic — Untested

**File:** `app/controllers/application_controller.rb`
**Risk: HIGH**

The `authenticate!` before_action, `current_user`, and `logged_in?` methods have no direct tests. The request specs bypass authentication entirely via `allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)`.

**What to test:**
- Unauthenticated users are redirected when accessing protected routes (`new`, `edit`, `create`, `update`, `destroy`)
- `current_user` returns nil when no session exists
- `current_user` returns the correct user when session has a valid `user_id`
- `logged_in?` returns correct boolean

### 5. Favorite/Unfavorite Actions — No Tests

**File:** `app/controllers/homes_controller.rb` (lines 74-94)
**Risk: MEDIUM**

The `favorite` and `unfavorite` actions are completely untested in both the Minitest and RSpec suites. These are AJAX endpoints critical to user interaction.

**What to test:**
- `POST /homes/:id/favorite` creates a Favorite record
- `POST /homes/:id/unfavorite` destroys a Favorite record
- Both actions require authentication
- `unfavorite` responds with JSON
- Edge cases: favoriting an already-favorited home, unfavoriting when no favorite exists

### 6. Home Model — Missing Business Logic Tests

**File:** `app/models/home.rb`
**Risk: MEDIUM**

Validations are well-tested, but the following methods have no coverage:

- **`Home#can_this_user_edit?(user)`** — Authorization logic, untested
- **`Home#can_this_user_destroy?(user)`** — Authorization logic, untested
- **`Home.search(search)`** — Search query logic, untested
- **`Home#create_derivatives`** — After-commit callback for image processing, untested
- **`belongs_to :created_by`** — Association not tested with Shoulda matchers

**What to test:**
- `can_this_user_edit?` returns true for the creator, false for other users
- `can_this_user_destroy?` returns true for the creator, false for other users
- `Home.search("cityname")` returns homes matching city, address, zip, state, or description
- `Home.search("xyz")` returns empty when nothing matches
- SQL injection safety of the search method (it uses `ILIKE` with string interpolation into the pattern — currently safe due to parameterized `where`, but worth verifying)

### 7. HomesHelper — No Tests

**File:** `app/helpers/homes_helper.rb`
**Risk: MEDIUM**

Two helper methods with conditional logic and zero test coverage:

- **`home_age_class(date)`** — Returns CSS class based on home age (old/new/standard). Has three branches, none tested.
- **`heart_class(home, user)`** — Returns filled/empty heart icon class based on favorite status. Untested.

**What to test:**
- `home_age_class` with a date > 30 days ago returns `"old-home"`
- `home_age_class` with a date within the last 2 days returns `"new-home"`
- `home_age_class` with a date between 2-30 days ago returns `"standard-home"`
- `heart_class` returns `"glyphicon-heart"` when a favorite exists
- `heart_class` returns `"glyphicon-heart-empty"` when no favorite exists

### 8. Search Functionality — No Integration Tests

**File:** `app/controllers/homes_controller.rb` (lines 6-13)
**Risk: MEDIUM**

The `index` action has search and pagination logic that is not covered by any request spec. The existing request spec only tests the default (non-search) index.

**What to test:**
- `GET /homes?search=cityname` returns matching homes
- `GET /homes?q=cityname` also works (aliased parameter)
- `GET /search?search=term` route works
- Pagination works correctly (more than 8 homes paginate to page 2)
- Default ordering is by price

### 9. Notifications Mailer — Broken Tests

**File:** `test/mailers/notifications_mailer_test.rb`
**Risk: MEDIUM**

The existing mailer tests are broken and do not match the actual mailer implementation:
- Tests call `NotificationsMailer.signup` with no arguments, but the method requires a `user_that_just_signed_up` argument
- Tests assert `from: "from@example.com"` but the mailer uses `from: "hello@TinyEstates.com"`
- Tests assert `subject: "Signup"` but the mailer uses `subject: "You signed up for Tiny Estates"`
- Tests call `NotificationsMailer.home_added` with no arguments, but the method requires a `home` argument

**What to fix and test:**
- Fix tests to pass actual model objects
- Assert correct sender, subject, and recipients
- Verify email body content

### 10. Authorization Enforcement in Controller Actions — Insufficient Testing

**File:** `app/controllers/homes_controller.rb`
**Risk: MEDIUM**

The request specs always mock authentication as the home's creator. There are no tests verifying that:

- A different user cannot edit another user's home
- A different user cannot update another user's home
- A different user cannot destroy another user's home
- The `edit` action redirects unauthorized users
- The `update` action redirects unauthorized users
- Bug: The `destroy` action calls `send_them_back_with_error` but does NOT `return` — meaning the home gets destroyed even when the user is unauthorized (line 66-71)

### 11. Pages Controller — Minimal Coverage

**File:** `app/controllers/pages_controller.rb`
**Risk: LOW**

Has only a single Minitest assertion that GET landing returns success. No RSpec equivalent exists.

**What to test:**
- `GET /` (root) renders the landing page
- `GET /pages/landing` renders the landing page
- Landing page uses `layout false`

### 12. Routing — No Route Specs

**File:** `config/routes.rb`
**Risk: LOW**

No routing specs exist. While request specs implicitly test some routes, the custom routes are not directly verified.

**What to test:**
- `POST /homes/:id/favorite` routes to `homes#favorite`
- `POST /homes/:id/unfavorite` routes to `homes#unfavorite`
- `GET /search` routes to `homes#index`
- Auth routes (`/auth/:provider`, `/auth/:provider/callback`, `/auth/failure`)
- Login/logout routes (`/login`, `/logout`)
- Shrine attachment download endpoint

---

## Bugs Found During Analysis

1. **`session_controller.rb:11`** — `NotificationsMailer.signup(@user)` references `@user` which is never assigned. Should likely be `current_user` or a local variable from `User.from_omniauth(...)`.

2. **`homes_controller.rb:66-68`** — The `destroy` action calls `send_them_back_with_error` for unauthorized users but does not `return` afterward. The redirect is issued but `@home.destroy` on line 70 still executes, deleting the home despite the user being unauthorized.

3. **`notifications_mailer_test.rb`** — All mailer tests are broken: wrong argument counts, wrong sender address, wrong subjects.

---

## Recommendations

### Immediate Actions

1. **Add SimpleCov** to `spec_helper.rb` to get actual coverage metrics on every test run.
2. **Consolidate on RSpec** — Remove or migrate the Minitest files. Having two frameworks creates confusion and the Minitest model tests are all empty placeholders.
3. **Create a Favorite factory** in `spec/factories/favorites.rb`.
4. **Fix the destroy authorization bug** in `homes_controller.rb` (add `return` after `send_them_back_with_error`).
5. **Fix the `@user` bug** in `session_controller.rb`.

### Test Priority Order

Write new tests in this order for maximum risk reduction:

1. **User model spec** (`spec/models/user_spec.rb`) — Test `from_omniauth`
2. **Favorite model spec** (`spec/models/favorite_spec.rb`) — Test associations
3. **Home model business logic** — Add tests for `search`, `can_this_user_edit?`, `can_this_user_destroy?`
4. **Authentication request specs** — Test that unauthenticated users are redirected
5. **Authorization request specs** — Test that users cannot modify other users' homes
6. **Favorite/unfavorite request specs** — Test the AJAX endpoints
7. **Session controller request spec** — Test login/logout/callback flows
8. **HomesHelper spec** — Test `home_age_class` and `heart_class`
9. **Search integration specs** — Test search and pagination
10. **Fix and update mailer tests** — Align with actual implementation
