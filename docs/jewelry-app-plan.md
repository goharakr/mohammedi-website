# Jewelry Preorder App — Planning Document

Status: **planning only** — nothing in this document has been built yet.
This is a plan for a separate app/tool to run your online, preorder-based
jewelry business. It is not tied to the tiles/stone catalogue website in
this repo; it lives here only because this repo is where the planning
branch was created.

## 1. The business, in one paragraph

You sell jewelry online, no physical shop. There's no single product
line/brand — every sale is a one-off item (a bracelet, a ring, whatever
someone orders). You buy on preorder from a supplier, sometimes against
an advance you've already paid her, and it takes about a month to
arrive. You post items to WhatsApp groups at a marked-up price, people
reply if they want one, and from there you need to track: who ordered
what, what it cost you, what you sold it for, who's paid, what you spent
on top (transport, bank charges), and how your supplier advance is being
used up. That's a lot of bookkeeping currently living in your head and
your WhatsApp chat history.

## 2. "An app" or "an agent"? — what's actually possible

These aren't really competing choices. An **app** is something you
operate directly — you tap, type, upload, and it stores/organizes things.
An **agent** implies something that reads and acts more on its own.

Here's the constraint that decides it: WhatsApp does not let any
third-party software — app or "agent," official or not — silently read
your group chats or DMs in the background. Nothing can watch your groups
for you unless you're the one relaying the message in (by forwarding,
sharing, or pasting it).

So the realistic design is **an app with an AI layer built into it**:
- You still forward/paste in the supplier's message, or a customer's "I
  want this."
- Once it's inside the app, AI does the tedious part: pulls the item and
  price out of messy text, suggests the markup and converted price,
  drafts the group post or the "your order is ready" message, flags
  "Maria hasn't paid yet," and tells you "this order used $32 of your
  $500 supplier advance."

It will feel like an agent helping you run the business, even though
technically it's an app with an AI assistant inside it — the boundary is
just that you feed it the message or photo; it can't reach into WhatsApp
by itself.

## 3. Feature 1 — Customer bookings & pickup notifications

**Flow you described:**
- You already have the customer's contact (imported into the app).
- Someone orders an item → you log a booking: customer, item (+ optional
  photo), price, amount they still owe.
- A month later the item arrives → you tap the customer's name in the
  app → the app opens WhatsApp (or SMS) to that person with a
  **pre-filled, editable message** ("Hi Maria, your ring has arrived,
  please come collect it") → you hit send.

**What this needs:**

| Piece | Detail |
|---|---|
| Contacts | Import from phone contacts once; after that, a **type-to-search field** — type "Ma" and matching contacts (e.g. all your Marias) show up in a dropdown, tap the right one. No re-typing numbers, no scrolling a long list. |
| Booking record | Customer, item description, photo, sale price, amount paid/owed, order date, status (`booked` → `arrived` → `collected`). |
| Notify button | One tap per customer → prefilled message → opens WhatsApp/SMS → you review and hit send. |
| Message templates | 2–3 canned messages you write once (e.g. "ready for pickup", "reminder to pay balance"), with `{name}`, `{item}`, `{amount}` filled in automatically. Fully editable before sending, every time. |
| Payment tracking | Mark paid/unpaid/partial per booking; a running list of "who still owes me money," with a simple paid/not-paid toggle. |
| Views | A simple list: active bookings, arrived-but-not-collected, overdue payments. |

No WhatsApp automation is required here — just data entry plus a deep
link that opens WhatsApp with the text already typed.

## 4. Feature 2 — Supplier price → markup → currency → group post

**Flow you described:**
- Supplier messages you a cost in USD, e.g. "$5".
- You **copy-paste** that message into the app (no manual re-typing of
  the number).
- You tick a couple of preset options describing the item (see item
  presets below), e.g. "Bracelet → Gold-plated → Zircon/American
  diamond."
- App applies your markup rule (e.g. "+$15") → you can also just tell it
  "add $15 to this one" if it varies.
- App converts the marked-up price to **Tanzanian Shilling (TSh) and
  Kenyan Shilling (KSh)** and writes the full post text for you.
- You have exactly two destination groups — **Trendyware Tanzania** and
  **Trendyware Kenya** — so you pick which one (or both) this item is
  for, and the app writes the matching post: the Tanzania group gets a
  post priced in TSh, the Kenya group gets one priced in KSh (posting to
  both just gives you both texts, one per group, instead of guessing
  which currency to lead with).
- You get a ready-made post like:
  `Gold-plated Bracelet with Zircon — $20 (TSh 52,000)` for Tanzania, and
  `Gold-plated Bracelet with Zircon — $20 (KSh 2,600)` for Kenya.
- You post that to the relevant WhatsApp group(s) — ideally the app does
  it, or at least gets you to one tap.
- Replies come back in the group (e.g. Maria: "I want the bangles you
  posted today") — you turn that into a Feature 1 booking for Maria
  without retyping the item/price, since the app already generated it,
  using the same contact type-to-search from Feature 1.

**What this needs:**

| Piece | Detail |
|---|---|
| Price input | Paste the supplier's WhatsApp text in; the app pulls the USD number out of it. |
| Item presets | A set of tickable fields you configure once and reuse per post — e.g. **Item type** (bracelet, ring, necklace, earrings...), **Material** (gold, gold-plated), **Stone** (none, zircon/American diamond, semi-precious, emerald, ruby, other). Ticking them assembles the item description automatically (e.g. "Gold-plated Bracelet with Zircon") instead of you typing it out each time. Presets are editable/extendable whenever you get a new item type. |
| Target group(s) | Tick **Tanzania**, **Kenya**, or both per item — controls which currency (or both) the generated post uses. The two groups and their currencies are set up once in Settings, not re-picked every time. |
| Markup rule | A default (e.g. always +$15) you can override per item; later, could support % markup too. |
| Currency conversion | Convert USD → TSh and KSh. Either you enter/update the exchange rate yourself in Settings, or the app pulls a live rate from a currency API. Manual entry is simpler and more predictable for pricing. |
| Message generator | Builds the full post text (item description + both prices) from a template you control, always editable before sending — never auto-sent without your OK. |
| Posting to groups | See the WhatsApp constraint in §9 — this is the one part that **cannot** be fully "one click, zero taps in WhatsApp" today. |
| "Claim" shortcut | Each posted item stays in the app as a pending item; when someone replies wanting it, you find them with the contact search and tap "book this item to them" — turns straight into a Feature 1 booking with the description and price already filled in. |

## 5. Feature 3 — Expenses & profit tracking

You mentioned wanting to see **roughly how much profit you're actually
making**, after costs beyond just the item price:

| Piece | Detail |
|---|---|
| Expense log | Record things like transport, bank/transfer charges, packaging — either attached to a specific order or as general overhead for a period. |
| Per-item profit | `sale price − supplier cost − expenses allocated to it` shown per booking. |
| Overall profit view | Totals over a chosen period (e.g. this month): total sales, total cost, total expenses, net profit. |
| Per-person profit | Since you and your three daughters (§6) each sell and keep your own earnings, the same totals broken down **by who made the sale** — "Susanna's profit this month," "Rashida's," "Alifia's," "Ramla's" — not just one combined number. |

This reuses the same booking records from Feature 1 — the cost price is
already captured there (from Feature 2), so profit-per-item is mostly
automatic once both are in place.

## 6. Feature 4 — Supplier advance / credit ledger

**Flow you described:**
- You send your supplier an advance, e.g. $500.
- As you place orders against her, each order's cost comes out of that
  advance.
- You want to see, at any time: how much of the $500 is used, how much
  is left, and which items were bought against it.

**What this needs:**

| Piece | Detail |
|---|---|
| Advance record | Amount sent, date, supplier (in case you use more than one). |
| Auto-deduction | Every booking's supplier cost (from Feature 2) is linked to an advance and subtracted from its running balance. |
| Balance view | "$500 advance → $312 used → $188 remaining," with the list of items it paid for. |
| Multiple advances | A running ledger, not just one number — so a new advance just starts a new balance once the old one runs out (or tops it up, your call). |

## 7. Feature 5 — Photo storage

You mentioned not knowing how you'd save all the item photos. The plan:
every booking (and every posted item in Feature 2) can have one or more
photos attached, stored by the app itself — not just left sitting in
your phone's camera roll — so they:
- stay organized by item/customer/date instead of a flat photo gallery,
- are backed up if your phone is lost or replaced,
- can be reused later (e.g. reposting the same style).

Photos get into the app either by taking/picking one directly in-app, or
— on Android — by forwarding a photo from WhatsApp straight to the app
via the system "Share" menu (see §9). Since one item photo can have
several customers waiting on it (e.g. five people all ordered the same
bangle style), tapping a photo shows **every customer linked to it** —
so once the box arrives, you open the photo and immediately see who
gets which piece, instead of trying to remember or dig through chats.

## 8. Feature 6 — Multiple users (you + three daughters)

**Flow you described:**
- Four people use this: you (Ramla) and your three daughters (Susanna,
  Rashida, Alifia). Everyone sells the same stuff, through the same
  supplier, into the same two groups — but each of you keeps your own
  earnings/share, so whatever one of you sells needs to be recorded
  under her own name, not lumped together.
- You explicitly said security isn't a concern here — this is family,
  not customers, so a simple login (not bank-grade security) is fine.

**What this needs:**

| Piece | Detail |
|---|---|
| Accounts | Four simple logins — e.g. each person picks her name from a list and sets any password she likes (shared or different, doesn't matter). No need for complex permissions or roles; everyone can do everything. |
| Attribution | Every item posted and every booking made records **who did it** (Susanna, Rashida, Alifia, or Ramla), so it's always clear whose sale it was — this is what powers the per-person profit view in Feature 3. |
| Shared data | Customers, the supplier, the two groups (Tanzania/Kenya), item presets, and message templates are the same for everyone — no need to re-enter any of that per user. |
| Shared vs. own bookings | Because the customer list is shared, any of you could technically see any customer — but bookings/sales themselves are still tagged to whoever made them, so "my sales" vs. "everyone's sales" are both easy views. |

Since this is a shared family business tool rather than customer-facing
software, this is the one area where we can deliberately keep things
simple (no password resets, no permission levels) rather than over-build
security nobody asked for.

## 9. The WhatsApp constraint (read this before we design further)

This affects Features 2 and 3 especially, so it's worth being upfront
about what's actually possible:

**Option A — Deep links / share sheet (recommended, works today, free)**
- The app can open WhatsApp with a message already typed in, using a
  `wa.me` / `whatsapp://send?text=...` link. For a *specific person*
  (Feature 1), this opens their chat directly — one tap to send.
- For **posting to a group** (Feature 2), WhatsApp does not let any
  outside app pick a specific group and auto-send — the official privacy
  design requires a human to pick the chat/group and tap Send inside
  WhatsApp itself. So the realistic flow is: app builds the message →
  opens WhatsApp's share sheet → **you pick the group(s)** → tap send.
  That's 1–2 taps, not zero, but no manual retyping.
- Receiving a **forwarded supplier/customer message or photo into the
  app**: on **Android**, an app can register itself in the system
  "Share" menu, so you forward the WhatsApp message/photo to the app
  like you'd forward it to any other app. On **iPhone**, this is more
  restricted but still possible with a proper native app (a "Share
  Extension"); a plain web app cannot receive shares on iOS.

**Option B — WhatsApp Business Platform (Cloud API)**
- The official way to send/receive WhatsApp messages programmatically
  without a human tapping Send.
- Real limitations that matter here: it **cannot post into WhatsApp
  groups at all** (group messaging isn't supported for businesses on
  this API — only 1:1 chats), and it can't read a group's incoming
  replies either. It also requires Meta business verification,
  pre-approved templates for messages sent outside a 24-hour reply
  window, and has a per-conversation cost.
- Given group posting and reading group replies are central to how you
  work, this option would only ever help with the 1:1 pickup
  notifications in Feature 1 — not Feature 2's posting/replies.

**Recommendation:** build on Option A for everything first — it's free,
compliant, and covers the real workflow (forward in, review/edit, tap to
send). Only consider Option B later, and only for 1:1 pickup
notifications, if removing that last tap is worth the verification/cost
overhead.

## 10. Platform choice — resolved: Android phone + laptop

You confirmed you need this on both an **Android phone** and a
**laptop**. That settles it cleanly: build it as a **web app**, ideally
an installable **PWA (Progressive Web App)**:
- On the **laptop**, it's just a website — open it in the browser, no
  install needed, easiest place to do data entry (typing item presets,
  reviewing profit totals, managing the advance ledger) with a keyboard
  and a bigger screen.
- On **Android**, the same app installs to your home screen like a real
  app, and — because it's Android — it can register in the system
  "Share" menu, so forwarding a supplier message or a photo from
  WhatsApp straight into the app works there too (see §9).
- One codebase, one place your data lives, used from either device —
  no need for a separate native app per platform. (This also fits
  naturally with this repo's existing stack, which is already a React +
  Vite web app with a Supabase backend for data storage.)
- Because you'll use it from two devices, the data (customers, bookings,
  items, expenses, advance ledger) needs to live in the cloud rather than
  only on one phone — so whatever you enter on your phone shows up on
  the laptop and vice versa.

## 11. App structure — pages, dashboard, ledger, report, and settings

You want this **organized into a small number of clear pages**, not
everything crammed onto one screen. Here's the structure:

**Main pages** (each of the four of you sees your own data by default,
with an option to switch to "everyone's"):

1. **Dashboard** (the home page/first screen) — the at-a-glance summary:
   total cost price, total selling price, total profit, how much you've
   sold this month, and your pending orders (bookings not yet collected).
2. **Sales** — the supplier → group tool from Feature 2: paste the
   supplier's price, tick the item presets, pick the group(s), review/
   edit the generated message, send it.
3. **Bookings** — everything currently booked from Feature 1: customer,
   item, price, and paid/owed status, all in one list.
4. **Delivery** — once items arrive: mark items as arrived, open a photo
   to see every customer waiting on it (Feature 5), one-tap "notify
   customer" messages, mark each as collected.
5. **Report** — see below; the one place all your ledgers come together.
6. **Settings** — see below; one-time setup + the app's configuration.

Each of Sales/Bookings/Delivery stays focused on its own job — nothing
about money/profit history clutters them directly. Historical detail
lives in the ledger.

**The ledger — attached to every page, editable, and pulled together in
Report:**

- Every page (Dashboard, Sales, Bookings, Delivery) has its own small
  **"View Ledger"** button at the top, scoped to that page's own
  activity — e.g. the Delivery page's ledger shows only delivery
  entries, so you're never hunting on another page for something that
  belongs here.
- Tapping it opens a **full-screen overlay** — no sidebar, no drawer, it
  covers the whole screen so you can see everything at once.
- **You can edit or delete any entry directly from the ledger** — if
  something was logged wrong, you fix it right there, not by hunting
  down the original booking/sale elsewhere.
- Filters are **dropdowns** (not rows of small buttons), and can be
  combined: **Item**, **Debt** (unpaid/owing only — read "depth wise" as
  "debt wise," flag if that's not what you meant), **Contact**, and
  **Date** (dropdown: **Today / This week / Last week / This month /
  Last month / Custom range**, the last one taking a from-date and
  to-date).

**Report page — every ledger in one place:**

- Pulls together the ledgers from all pages into a single view, instead
  of checking each page separately.
- **Category checkboxes** — small tick-boxes for **Sales**, **Bookings**,
  **Delivery** (and so on); tick just "Delivery" and only delivery
  entries show, tick nothing/everything and you see it all combined.
- The same **Item** and **Contact** filters as the per-page ledgers.
- The same **Date** dropdown (Today / This week / Last week / This month
  / Last month / Custom range).
- Same editing rules as any ledger — fix a wrong entry right from here.

**Settings page — starting balances + configuration:**

Before you start really using the app, you enter your business's
**current real-world state** so the app isn't starting from zero when
you already have money and orders in motion:

| Starting value | What it captures |
|---|---|
| Supplier advance already given | Whatever balance you've already sent your supplier before the app existed (feeds Feature 4's ledger). |
| Cash already in hand | Money you're currently holding from past sales. |
| Sales already made | Historical total sales, so this month/lifetime totals aren't missing your pre-app history. |
| Customer amounts owed | What customers already owe you from before the app started (feeds the Debt filter). |
| Expenses so far | Whatever transport/bank-charge totals you've already incurred. |
| Starting profit | Not entered by you — the app **calculates and shows** this from the four figures above, so you get a sanity-check number rather than typing it in yourself. |

All of these are one-time manual entries (typed in once, editable later
if you realize a number was off) — this is what makes the Dashboard and
Report accurate from day one instead of pretending the business started
at zero.

Settings is also where the shared configuration lives day-to-day: the
two groups and their currencies, the default markup rule, exchange rate
(manual or live — open question), item presets, and message templates.

## 12. Data model (sketch)

```
User (Ramla, Susanna, Rashida, Alifia)
  id, name, login

Customer
  id, name, phone, notes

Supplier
  id, name

SupplierAdvance
  id, supplier_id, amount, sent_at, balance_remaining

Group (Trendyware Tanzania, Trendyware Kenya)
  id, name, currency_code

Item (a posted/priced item — one photo can serve several Bookings)
  id, description, photo_url, group_id,
  supplier_cost, supplier_advance_id (nullable),
  markup_applied, sale_price,
  posted_by (User), posted_at

Booking (an Item claimed by a Customer)
  id, item_id, customer_id,
  amount_paid, amount_owed,
  status: booked | arrived | collected,
  sold_by (User), ordered_at, arrived_at

Expense
  id, label (e.g. "transport", "bank charges"),
  amount, booking_id (nullable, for allocation), incurred_at

PriceRule
  id, label (e.g. "default markup"), amount or percent

MessageTemplate
  id, label (e.g. "pickup ready", "group post"), body_with_placeholders

ExchangeRate
  currency_code, rate_to_usd, updated_at

OpeningBalance (one-time Settings entry, per starting figure)
  id, label (supplier_advance | cash_in_hand | past_sales |
  customer_debt | past_expenses), amount, entered_at
```

Every Item/Booking/Expense/SupplierAdvance row above also needs to
support edit and delete from the ledger UI, not just create — that's a
first-class requirement, not an afterthought.

## 13. Suggested phases

**Phase 1 — MVP (structure + bookings + settings)**
- The six pages from §11 (Dashboard, Sales, Bookings, Delivery, Report,
  Settings) built from the start, so the app never feels like it needs
  reorganizing later — features get slotted into these pages, not
  bolted on wherever's convenient.
- Settings' opening-balance entry (supplier advance, cash in hand, past
  sales, customer debt, past expenses) so the app reflects real
  business state from day one, not zero.
- Accounts for all four of you, add/import contacts, create bookings,
  mark arrived, one-tap prefilled WhatsApp/SMS message to a customer,
  basic paid/owed tracking, attach a photo per booking.
- Dashboard shows cost/selling price, profit, this month's sales,
  pending orders — fed by the opening balances plus whatever's entered.

**Phase 2 — Pricing & posting tool**
- Manual price entry → markup → currency conversion (per Tanzania/Kenya
  group) → editable message → share sheet to post to a group → "claim"
  an item into a booking when someone replies wanting it. Lives on the
  Sales page.

**Phase 3 — Ledger, Report, and money tracking**
- Expense log and profit view, including the per-person breakdown
  (Feature 3).
- Supplier advance ledger with auto-deduction per order (Feature 4).
- The per-page **View Ledger** overlay (§11) — full-screen popup,
  editable/deletable entries, dropdown filters for item/debt/contact/
  date.
- The **Report** page — every ledger combined, with category checkboxes
  (Sales/Bookings/Delivery) plus the same item/contact/date filters.

**Phase 4 — Quality of life**
- Receive-shared-message/photo support (Android first) so you can
  forward straight from WhatsApp instead of retyping (Feature 5, and
  faster input for Feature 2's item posting).
- Tap a photo to see every customer linked to it, for sorting arrivals.
- Overdue-payment reminders, simple search/filter over bookings.
- AI-assisted parsing: paste a messy supplier message or group reply and
  have the app pull out item/price/customer automatically (the "agent"
  feel described in §2).

**Phase 5 — optional, only if needed**
- WhatsApp Business Cloud API for fully automatic 1:1 pickup
  notifications (does not extend to group posting or reading group
  replies — see §9).

## 14. Open questions for you

Resolved so far: platform is Android + laptop as a web app (§10);
currencies are USD in, TSh/KSh out per group (§4); one shared supplier
and four user accounts (§8); page structure and ledger filters (§11).
Still open:

1. In §11, "depth wise" was read as **"debt wise"** (filter the ledger to
   unpaid/owing orders) — confirm that's right, or tell me what you
   actually meant.
2. For currency conversion: type in/update the rate yourself in Settings,
   or should the app fetch a live exchange rate automatically?
3. Is the markup always a flat add-on (+$15), or does it vary by item
   type / sometimes a percentage?
4. Expenses like transport/bank charges — do they usually apply to one
   specific order, or are they more general monthly overhead you'd want
   split across everything sold that period?
4. Do you want this as its own standalone app, or does it make sense to
   fold it into an existing tool you already use?

Once you confirm these, the next step would be a short spec for Phase 1
(screens + exact fields) before any code gets written.
