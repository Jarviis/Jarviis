fixture.preload("issue.json", "issues.json");
describe('Issues', function() {
  describe('Model', function() {
    beforeEach(function () {
      server = sinon.fakeServer.create();
      this.fixtures = fixture.load("issue.json", true);
      this.issue = new Jarviis.Entities.Issue();
      this.issue.fetch();
      server.requests[0].respond(
        200,
        { "Content-Type": "application/json" },
        JSON.stringify(this.fixtures[0])
      );
    });
    afterEach(function() {
      server.restore();
    });

    it('should have a defined Marionette module', function() {
      expect(Jarviis.Entities.Issue).toBeDefined();
    });

    it('which will have a correct API url', function() {
      expect(Jarviis.Entities.Issue.prototype.urlRoot).toBe('/api/v1/issues');
    });

    it('and also, an idAttribute.', function() {
      expect(Jarviis.Entities.Issue.prototype.idAttribute).toBe('id');
    });

    it('Model should be able to create a valid instace', function() {
      expect(this.issue).toBeDefined();
      expect(this.issue.attributes).not.toEqual({});
    });

    it('which has correct attributes.', function() {
      expect(this.issue.get('name')).toBe('Jarviis is kinda awesome');
      expect(this.issue.get('description')).toContain('Lorem ipsum dolor sit amet');
      expect(this.issue.get('state')).toBe('resolved');
      expect(this.issue.get('assignee_id')).toBe(2);
    });
  });
  describe('Collection', function() {
    beforeEach(function () {
      server = sinon.fakeServer.create();
      this.fixtures = fixture.load("issues.json", true);
      this.issues = new Jarviis.Entities.IssueCollection(this.fixtures[0]);
      this.issues.fetch();
      server.requests[0].respond(
        200,
        { "Content-Type": "application/json" },
        JSON.stringify(this.fixtures[0])
      );
    });
    afterEach(function() {
      server.restore();
    });
    it('should also have a defined Marionette module', function() {
      expect(Jarviis.Entities.IssueCollection).toBeDefined();
    });
    it('which will return a correct API url from related function', function() {
      expect(Jarviis.Entities.IssueCollection.prototype.url()).toBe('/api/v1/issues');
    });
    it('Collection should be able to create a valid instace', function() {
      expect(this.issues).toBeDefined();
      expect(this.issues.models).not.toEqual([]);
      expect(this.issues.models.length).toBe(15);
    });
  });
});
