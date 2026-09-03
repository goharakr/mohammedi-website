# Jewelry Preorder App — Planning Document

Status: **planning only** — nothing in this document has been built yet.
This is a plan for a separate app to run your online, preorder-based
jewelry business. It is not tied to the tiles/stone catalogue website
in this repo; it lives here only because this repo is where the planning
branch was created.

## 1. The business, in one paragraph

You sell jewelry online, no physical shop. There's no single product
line/brand — every sale is a one-off item (a bracelet, a ring, whatever
someone orders). You buy on preorder from a supplier and it takes about
a month to arrive. Two everyday chores are eating your time:

1. Remembering **who ordered what, for how much, and messaging them**
   the moment their order arrives.
2. Taking a **supplier's cost message**, adding your markup, converting
   it to local currency, and **posting a price list to your WhatsApp
   groups** — over and over, by hand.

The app's job is to remove the manual, repetitive parts of both.

## 2. Feature 1 — Customer bookings & pickup notifications

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
| Contacts | Import from phone contacts (pick from the OS contact picker) instead of retyping numbers. |
| Booking record | Customer, item description, photo (optional), price, amount paid/owed, order date, status (`booked` → `arrived` → `collected`). |
| Photo capture | Either snap a photo in-app, or **receive a photo shared from WhatsApp** via the OS "Share" menu (see §4 — this only works reliably on Android). |
| Notify button | One tap per customer → prefilled message → opens WhatsApp/SMS → you review and hit send. |
| Message templates | 2–3 canned messages you write once (e.g. "ready for pickup", "reminder to pay balance"), with `{name}`, `{item}`, `{amount}` filled in automatically. Fully editable before sending, every time. |
| Payment tracking | Mark paid/unpaid/partial per booking; a running list of "who still owes me money." |
| Views | A simple list: active bookings, arrived-but-not-collected, overdue payments. |

This part is straightforward — no WhatsApp automation is required, just
data entry + a deep link that opens WhatsApp with the text already typed.

## 3. Feature 2 — Supplier price → markup → currency → post

**Flow you described:**
- Supplier messages you a cost, e.g. "$5".
- You forward that message to the app (or type it in).
- App applies your markup rule (e.g. "+$15") → you can also just tell it
  "add $15 to this one" if it varies.
- App shows the result converted into **local shillings** (see open
  question below on which currencies).
- You get a ready-made post like:
  `Ring — $20 (TSh 52,000 / KSh 2,600)`
- You post that to your WhatsApp groups — ideally the app does it, or at
  least gets you to one tap.

**What this needs:**

| Piece | Detail |
|---|---|
| Price input | Type the cost, or forward/paste the supplier's WhatsApp text; the app pulls the number out of it. |
| Markup rule | A default (e.g. always +$15) you can override per item; later, could support % markup too. |
| Currency conversion | Convert USD → your local currencies. Needs a source: either you enter/update the exchange rate yourself in Settings, or the app pulls a live rate from a currency API. Manual entry is simpler and more predictable for pricing; live rates add complexity for little benefit if you round prices anyway. |
| Message generator | Builds the post text from a template you control, always editable before sending — never auto-sent without your OK. |
| Posting to groups | See the WhatsApp constraint below — this is the one part that **cannot** be fully "one click, zero taps in WhatsApp" today. |

## 4. The WhatsApp constraint (read this before we design further)

This affects both features, so it's worth being upfront about what's
actually possible, so the plan doesn't promise something WhatsApp won't
allow:

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
- Receiving a **forwarded supplier message or photo into the app**: on
  **Android**, an app can register itself in the system "Share" menu, so
  you forward the WhatsApp message/photo to the app like you'd forward
  it to any other app. On **iPhone**, this is more restricted but still
  possible with a proper native app (a "Share Extension"); a plain web
  app cannot receive shares on iOS.

**Option B — WhatsApp Business Platform (Cloud API)**
- This is the official way to send/receive WhatsApp messages
  programmatically without a human tapping Send.
- Real limitations that matter for you: it **cannot post into WhatsApp
  groups at all** (group messaging isn't supported for businesses on this
  API — only 1:1 chats). It also requires Meta business verification,
  pre-approved message templates for anything sent outside a 24-hour
  reply window, and has a per-conversation cost.
- Given you specifically want group posting, this option would only help
  with the 1:1 customer notifications in Feature 1 (fully automatic, no
  tap needed) — it would not solve the group-posting half of Feature 2.

**Recommendation:** build on Option A for both features first (it's
free, compliant, and covers ~90% of the manual work you described). Only
consider Option B later, and only for the 1:1 pickup notifications, if
you decide it's worth the verification/cost overhead to remove that last
tap.

## 5. Platform choice

This determines a lot, so it needs your input:

- **What phone do you use — Android or iPhone?** Android supports the
  "receive a shared WhatsApp message/photo into the app" flow much more
  simply (including from an installed web app), which matters for how
  easily supplier messages and photos get into the app. iPhone needs a
  proper native app to do the same thing.
- If it's just for your own use (not customer-facing), a lightweight
  option is an installable **web app (PWA)** — reuses ordinary web
  technology, can be installed to your home screen, and on Android can
  receive shared content like a native app. If you're on iPhone, or want
  a smoother "share into app" experience, a small native app (e.g. React
  Native, since it can share code with a web version) is the safer bet.

## 6. Data model (sketch)

```
Customer
  id, name, phone, notes

Booking
  id, customer_id, item_description, photo_url,
  supplier_cost, markup_applied, sale_price,
  amount_paid, amount_owed,
  status: booked | arrived | collected,
  ordered_at, arrived_at

PriceRule
  id, label (e.g. "default markup"), amount or percent

MessageTemplate
  id, label (e.g. "pickup ready"), body_with_placeholders

ExchangeRate
  currency_code, rate_to_usd, updated_at
```

## 7. Suggested phases

**Phase 1 — MVP (customer bookings)**
- Add/import contacts, create bookings, mark arrived, one-tap
  prefilled WhatsApp/SMS message to a customer, basic paid/owed tracking.

**Phase 2 — Pricing tool**
- Manual price entry → markup → currency conversion → editable message →
  share sheet to post to a group.

**Phase 3 — Quality of life**
- Receive-shared-message/photo support (Android first) so you can
  forward straight from WhatsApp instead of retyping.
- Overdue-payment reminders, simple search/filter over bookings.

**Phase 4 — optional, only if needed**
- WhatsApp Business Cloud API for fully automatic 1:1 pickup
  notifications (does not extend to group posting — see §4).

## 8. Open questions for you

1. Android, iPhone, or both? (changes the platform recommendation in §5)
2. Which two currencies exactly — Tanzanian Shilling (TSh) and Kenyan
   Shilling (KSh)? Any others?
3. For currency conversion: type in/update the rate yourself in Settings,
   or should the app fetch a live exchange rate automatically?
4. Is the markup always a flat add-on (+$15), or does it vary by item
   type / sometimes a percentage?
5. Do you want this as its own separate app, or does it make sense to
   fold it into an existing tool you already use?

Once you confirm these, the next step would be a short spec for Phase 1
(screens + exact fields) before any code gets written.
