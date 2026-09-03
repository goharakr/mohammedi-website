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
| Contacts | Import from phone contacts (pick from the OS contact picker) instead of retyping numbers. |
| Booking record | Customer, item description, photo, sale price, amount paid/owed, order date, status (`booked` → `arrived` → `collected`). |
| Notify button | One tap per customer → prefilled message → opens WhatsApp/SMS → you review and hit send. |
| Message templates | 2–3 canned messages you write once (e.g. "ready for pickup", "reminder to pay balance"), with `{name}`, `{item}`, `{amount}` filled in automatically. Fully editable before sending, every time. |
| Payment tracking | Mark paid/unpaid/partial per booking; a running list of "who still owes me money," with a simple paid/not-paid toggle. |
| Views | A simple list: active bookings, arrived-but-not-collected, overdue payments. |

No WhatsApp automation is required here — just data entry plus a deep
link that opens WhatsApp with the text already typed.

## 4. Feature 2 — Supplier price → markup → currency → group post

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
- Replies come back in the group (e.g. Maria: "I want the bangles you
  posted today") — you turn that into a Feature 1 booking for Maria
  without retyping the item/price, since the app already generated it.

**What this needs:**

| Piece | Detail |
|---|---|
| Price input | Type the cost, or forward/paste the supplier's WhatsApp text; the app pulls the number out of it. |
| Markup rule | A default (e.g. always +$15) you can override per item; later, could support % markup too. |
| Currency conversion | Convert USD → your local currencies. Either you enter/update the exchange rate yourself in Settings, or the app pulls a live rate from a currency API. Manual entry is simpler and more predictable for pricing. |
| Message generator | Builds the post text from a template you control, always editable before sending — never auto-sent without your OK. |
| Posting to groups | See the WhatsApp constraint in §8 — this is the one part that **cannot** be fully "one click, zero taps in WhatsApp" today. |
| "Claim" shortcut | Each posted item stays in the app as a pending item; when someone replies wanting it, you pick them from contacts and tap "book this item to them" — turns straight into a Feature 1 booking with the price already filled in. |

## 5. Feature 3 — Expenses & profit tracking

You mentioned wanting to see **roughly how much profit you're actually
making**, after costs beyond just the item price:

| Piece | Detail |
|---|---|
| Expense log | Record things like transport, bank/transfer charges, packaging — either attached to a specific order or as general overhead for a period. |
| Per-item profit | `sale price − supplier cost − expenses allocated to it` shown per booking. |
| Overall profit view | Totals over a chosen period (e.g. this month): total sales, total cost, total expenses, net profit. |

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
via the system "Share" menu (see §8).

## 8. The WhatsApp constraint (read this before we design further)

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

## 9. Platform choice

This determines a lot, so it needs your input:

- **What phone do you use — Android or iPhone?** Android supports the
  "receive a shared WhatsApp message/photo into the app" flow much more
  simply (including from an installed web app), which matters for how
  easily supplier messages, group replies, and photos get into the app.
  iPhone needs a proper native app to do the same thing.
- If it's just for your own use (not customer-facing), a lightweight
  option is an installable **web app (PWA)** — reuses ordinary web
  technology, can be installed to your home screen, and on Android can
  receive shared content like a native app. If you're on iPhone, or want
  a smoother "share into app" experience, a small native app (e.g. React
  Native, so it can share code with a web version) is the safer bet.

## 10. Data model (sketch)

```
Customer
  id, name, phone, notes

Supplier
  id, name

SupplierAdvance
  id, supplier_id, amount, sent_at, balance_remaining

Item (a posted/priced item, before anyone claims it)
  id, description, photo_url,
  supplier_cost, supplier_advance_id (nullable),
  markup_applied, sale_price,
  posted_at

Booking (an Item claimed by a Customer)
  id, item_id, customer_id,
  amount_paid, amount_owed,
  status: booked | arrived | collected,
  ordered_at, arrived_at

Expense
  id, label (e.g. "transport", "bank charges"),
  amount, booking_id (nullable, for allocation), incurred_at

PriceRule
  id, label (e.g. "default markup"), amount or percent

MessageTemplate
  id, label (e.g. "pickup ready", "group post"), body_with_placeholders

ExchangeRate
  currency_code, rate_to_usd, updated_at
```

## 11. Suggested phases

**Phase 1 — MVP (customer bookings)**
- Add/import contacts, create bookings, mark arrived, one-tap
  prefilled WhatsApp/SMS message to a customer, basic paid/owed tracking,
  attach a photo per booking.

**Phase 2 — Pricing & posting tool**
- Manual price entry → markup → currency conversion → editable message →
  share sheet to post to a group → "claim" an item into a booking when
  someone replies wanting it.

**Phase 3 — Money tracking**
- Expense log and profit view (Feature 3).
- Supplier advance ledger with auto-deduction per order (Feature 4).

**Phase 4 — Quality of life**
- Receive-shared-message/photo support (Android first) so you can
  forward straight from WhatsApp instead of retyping (Feature 5, and
  faster input for Feature 2's item posting).
- Overdue-payment reminders, simple search/filter over bookings.
- AI-assisted parsing: paste a messy supplier message or group reply and
  have the app pull out item/price/customer automatically (the "agent"
  feel described in §2).

**Phase 5 — optional, only if needed**
- WhatsApp Business Cloud API for fully automatic 1:1 pickup
  notifications (does not extend to group posting or reading group
  replies — see §8).

## 12. Open questions for you

1. Android, iPhone, or both? (changes the platform recommendation in §9)
2. Which currencies exactly — Tanzanian Shilling (TSh) and Kenyan
   Shilling (KSh)? Any others?
3. For currency conversion: type in/update the rate yourself in Settings,
   or should the app fetch a live exchange rate automatically?
4. Is the markup always a flat add-on (+$15), or does it vary by item
   type / sometimes a percentage?
5. Expenses like transport/bank charges — do they usually apply to one
   specific order, or are they more general monthly overhead you'd want
   split across everything sold that period?
6. Do you use one supplier or several? (affects whether the advance
   ledger needs to track multiple suppliers separately)
7. Do you want this as its own standalone app, or does it make sense to
   fold it into an existing tool you already use?

Once you confirm these, the next step would be a short spec for Phase 1
(screens + exact fields) before any code gets written.
