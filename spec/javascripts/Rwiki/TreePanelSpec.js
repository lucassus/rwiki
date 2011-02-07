describe("Rwiki.TreePanel", function() {
  var treePanel;
  var root;

  beforeEach(function() {
    root = new Rwiki.Tree.Node({
      baseName: '.',
      text: 'Home',
      children: [{
        baseName: 'test.txt',
        text: 'test.txt',
        leaf: true
      }, {
        baseName: 'Develop',
        text: 'Develop',
        children: [{
          baseName: 'Ruby.txt',
          text: 'Ruby',
          leaf: true
        }]
      }]
    });

    var treeContent = $('<div />').attr('id', 'tree-div');
    $('#jasmine_content').append(treeContent);

    treePanel = new Rwiki.TreePanel({
      renderTo: 'tree-div',
      loader: new Rwiki.Tree.Loader({preloadChildren: true}),
      root: root
    });
  });

  afterEach(function() {
    $('#jasmine_content').empty();
  });

  describe(":findNodeByPath function", function() {
    it("should find root node", function() {
      var node = treePanel.findNodeByPath('.');
      expect(node).not.toBeNull();
    }),

    it("should find ./test.txt node", function() {
      var node = treePanel.findNodeByPath('./test.txt');

      expect(node).not.toBeNull();
      expect(node.getBaseName()).toEqual('test.txt');
      expect(node.getPath('baseName')).toEqual('./test.txt');
    });

    it("should find ./Develop/Ruby.txt node", function() {
      var node = treePanel.findNodeByPath('./Develop/Ruby.txt');
      
      expect(node).not.toBeNull();
      expect(node.getBaseName()).toEqual('Ruby.txt');
      expect(node.getPath('baseName')).toEqual('./Develop/Ruby.txt');
    });

    it("should not find ./Develop/Non-existing.txt", function() {
      var node = treePanel.findNodeByPath('./Develop/Non-existing.txt');
      expect(node).toBeNull();
    });
  });

  describe(":onClick handler", function() {
    var node = {};

    describe("for leaf node", function() {
      beforeEach(function() {
        node.isLeaf = jasmine.createSpy('node.isLeaf').andReturn(true);
        node.getPath = jasmine.createSpy('node.getPath').andReturn('./path');

        spyOn(treePanel, 'fireEvent');
        treePanel.onClick(node);
      });

      it("should fire event", function() {
        expect(treePanel.fireEvent).toHaveBeenCalledWith('rwiki:pageSelected', new Rwiki.Data.Node({path: './path'}));
      });
    });
  });

  describe(":onFolderCreated handler", function() {
    beforeEach(function() {
      var node = new Rwiki.Data.Node({
        path: './Develop/New folder',
        parentPath: './Develop'
      });

      treePanel.onFolderCreated(node);
    });

    it("should create and append a valid node", function() {
      var node = treePanel.findNodeByPath('./Develop/New folder');

      expect(node).not.toBeNull();
      expect(node.getBaseName()).toEqual('New folder');
      expect(node.attributes.text).toEqual('New folder');
      expect(node.isLeaf()).toBeFalsy();
    });
  });

  describe(":onPageCreated handler", function() {
    beforeEach(function() {
      var node = new Rwiki.Data.Node({
        path: './Develop/New page.txt',
        parentPath: './Develop'
      });
      
      treePanel.onPageCreated(node);
    });

    it("should create and append a valid node", function() {
      var node = treePanel.findNodeByPath('./Develop/New page.txt');

      expect(node).not.toBeNull();
      expect(node.getBaseName()).toEqual('New page.txt');
      expect(node.attributes.text).toEqual('New page');
      expect(node.isLeaf()).toBeTruthy();
    });
  });

  describe(":onNodeRenamed handler", function() {
    beforeEach(function() {
      var node = new Rwiki.Data.Node({
        path: './Develop/Python.txt',
        oldPath: './Develop/Ruby.txt'
      });

      treePanel.onNodeRenamed(node);
    });

    it("should rename node", function() {
      var oldNode = treePanel.findNodeByPath('./Develop/Ruby.txt');
      expect(oldNode).toBeNull();

      var node = treePanel.findNodeByPath('./Develop/Python.txt');
      expect(node).not.toBeNull();
      expect(node.getBaseName()).toEqual('Python.txt');
      expect(node.attributes.text).toEqual('Python');
      expect(node.isLeaf()).toBeTruthy();
    });
  });

  describe(":onNodeDeleted handler", function() {
    beforeEach(function() {
      var data = {
        path: './Develop/Ruby.txt'
      };

      treePanel.onNodeDeleted(data);
    });

    it("should delete node", function() {
      var node = treePanel.findNodeByPath('./Develop/Ruby.txt');
      expect(node).toBeNull();
    });
  });
});
