* User
   * first name, last name
   * gender
   * birthday
   * weight
   * height
   * photo
   * preferences (list: "dietary", "fitness")
   * role (user, expert)

* User - Expert (expert has many users)
   * user id
   * expert id
   * is active

* User Plan
   * expert id
   * user id
   * is active

* User Plan Attribute
   * user plan id
   * plan ("drink 3 glasses of water")

* User Plan Activity
   * user plan attribute id
   * activity date
   * NOTE: insert a row if checked; remove if unchecked

* Chat Message
   * to
   * from
   * text
