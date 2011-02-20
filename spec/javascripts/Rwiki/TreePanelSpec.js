describe("Rwiki.TreePanel", function() {
  var treePanel;
  var root;

  beforeEach(function() {
    root = new Rwiki.Tree.Node({
      baseName: '.',
      text: 'Home',
      children: [{
        baseName: 'Test',
        text: 'Test',
        leaf: true
      }, {
        baseName: 'Develop',
        text: 'Develop',
        children: [{
          baseName: 'Ruby',
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
      var node = treePanel.findNodeByPath('/Home');
      expect(node).not.toBeNull();
    }),

    it("should find '/Home/Test' node", function() {
      var node = treePanel.findNodeByPath('/Home/Test');

      expect(node).not.toBeNull();
      expect(node.getName()).toEqual('Test');
      expect(node.getPath()).toEqual('/Home/Test');
    });

    it("should find '/Home/Develop/Ruby' node", function() {
      var node = treePanel.findNodeByPath('/Home/Develop/Ruby');

      expect(node).not.toBeNull();
      expect(node.getName()).toEqual('Ruby');
      expect(node.getPath()).toEqual('/Home/Develop/Ruby');
    });

    it("should not find '/Home/Develop/Non-existing'", function() {
      var node = treePanel.findNodeByPath('/Home/Develop/Non-existing');
      expect(node).toBeNull();
    });
  });

//  describe(":onClick handler", function() {
//    var node = {};
//
//    describe("for leaf node", function() {
//      beforeEach(function() {
//        node.isLeaf = jasmine.createSpy('node.isLeaf').andReturn(true);
//        node.getPath = jasmine.createSpy('node.getPath').andReturn('/Home/path');
//
//        spyOn(treePanel, 'fireEvent');
//        treePanel.onClick(node);
//      });
//
//      it("should fire event", function() {
//        expect(treePanel.fireEvent).toHaveBeenCalledWith('rwiki:pageSelected', new Rwiki.Data.Node({path: '/Home/path'}));
//      });
//    });
//  });
//
//  describe(":onFolderCreated handler", function() {
//    beforeEach(function() {
//      var node = new Rwiki.Data.Node({
//        path: '/Home/Develop/New folder',
//        parentPath: '/Home/Develop'
//      });
//
//      treePanel.onFolderCreated(node);
//    });
//
//    it("should create and append a valid node", function() {
//      var node = treePanel.findNodeByPath('/Home/Develop/New folder');
//
//      expect(node).not.toBeNull();
//      expect(node.getBaseName()).toEqual('New folder');
//      expect(node.attributes.text).toEqual('New folder');
//      expect(node.isLeaf()).toBeFalsy();
//    });
//  });
//
//  describe(":onPageCreated handler", function() {
//    beforeEach(function() {
//      var node = new Rwiki.Data.Node({
//        path: '/Home/Develop/New page',
//        parentPath: '/Home/Develop'
//      });
//
//      treePanel.onPageCreated(node);
//    });
//
//    it("should create and append a valid node", function() {
//      var node = treePanel.findNodeByPath('/Home/Develop/New page');
//
//      expect(node).not.toBeNull();
//      expect(node.getBaseName()).toEqual('New page');
//      expect(node.attributes.text).toEqual('New page');
//      expect(node.isLeaf()).toBeTruthy();
//    });
//  });
//
//  describe(":onNodeRenamed handler", function() {
//    beforeEach(function() {
//      var node = new Rwiki.Data.Node({
//        path: '/Home/Develop/Python',
//        oldPath: '/Home/Develop/Ruby'
//      });
//
//      treePanel.onPageRenamed(node);
//    });
//
//    it("should rename node", function() {
//      var oldNode = treePanel.findNodeByPath('/Home/Develop/Ruby');
//      expect(oldNode).toBeNull();
//
//      var node = treePanel.findNodeByPath('/Home/Develop/Python');
//      expect(node).not.toBeNull();
//      expect(node.getBaseName()).toEqual('Python.txt');
//      expect(node.attributes.text).toEqual('Python');
//      expect(node.isLeaf()).toBeTruthy();
//    });
//  });
//
//  describe(":onNodeDeleted handler", function() {
//    beforeEach(function() {
//      var data = {
//        path: '/Home/Develop/Ruby'
//      };
//
//      treePanel.onPageDeleted(data);
//    });
//
//    it("should delete node", function() {
//      var node = treePanel.findNodeByPath('/Home/Develop/Ruby');
//      expect(node).toBeNull();
//    });
//  });
});
