1. Issues (POST/GET/DELETE)
  * state (open, resolved, closed, wontfix)
  * name
  * description
  * assignee (user*)
  * reporter (user*)
  * timestamp
  * due date
  * parent_id (if truthy then subtask else normal)
  * watchers (future work)

2. Users details

3. Sprints (has_many issues)
  * title
  * description
  * due date

4. Comments (katw apo ta issues)

5. My assigned issues & my reported issues (GET)

6. Create issue (POST)

7. Update issue (POST)

8. websockets synchronization for everything (in node?)

