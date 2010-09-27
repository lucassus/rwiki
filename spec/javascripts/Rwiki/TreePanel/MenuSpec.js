describe("Rwiki.TreePanel.Menu", function() {
  var menu;

  beforeEach(function() {
    menu = new Rwiki.TreePanel.Menu();
  });

  describe("events list", function() {
    it("should contain createFolder event", function() {
      expect(menu.events.createFolder).toBeDefined();
    });

    it("should contain createPage event", function() {
      expect(menu.events.createPage).toBeDefined();
    });

    it("should contain renameNode event", function() {
      expect(menu.events.renameNode).toBeDefined();
    });

    it("should contain deleteNode event", function() {
      expect(menu.events.deleteNode).toBeDefined();
    });
  });

  describe(":show method", function() {
    var node = {};
    var xy = {};

    beforeEach(function() {
      node.select = jasmine.createSpy('select');
      menu.showAt = jasmine.createSpy('showAt');
    });

    describe("when root node is selected", function() {
      beforeEach(function() {
        node.id = Rwiki.rootFolderName;
        node.attributes = {
          cls: 'folder'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      })

      it("should disable 'delete node' option", function() {
        expect(menu.findById('delete-node').disabled).toBeTruthy();
      });

      it("should disable 'rename node' option", function() {
        expect(menu.findById('rename-node').disabled).toBeTruthy();
      });

      it("should enable 'create folder' option", function() {
        expect(menu.findById('create-folder').disabled).toBeFalsy();
      });

      it("should enable 'create page' option", function() {
        expect(menu.findById('create-page').disabled).toBeFalsy();
      });
    });

    describe("when folder node is selected", function() {
      beforeEach(function() {
        node.id = './folder';
        node.attributes = {
          cls: 'folder'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      })

      it("should enable 'delete node' option", function() {
        expect(menu.findById('delete-node').disabled).toBeFalsy();
      });

      it("should enable 'rename node' option", function() {
        expect(menu.findById('rename-node').disabled).toBeFalsy();
      });

      it("should enable 'create folder' option", function() {
        expect(menu.findById('create-folder').disabled).toBeFalsy();
      });

      it("should enable 'create page' option", function() {
        expect(menu.findById('create-page').disabled).toBeFalsy();
      });
    });

    describe("when page node is selected", function() {
      beforeEach(function() {
        node.id = './page.txt';
        node.attributes = {
          cls: 'page'
        };

        menu.show(node, xy);
      });

      it("should select node", function() {
        expect(node.select).toHaveBeenCalled();
      });

      it("should show the menu", function() {
        expect(menu.showAt).toHaveBeenCalledWith(xy);
      })

      it("should enable 'delete node' option", function() {
        expect(menu.findById('delete-node').disabled).toBeFalsy();
      });

      it("should enable 'rename node' option", function() {
        expect(menu.findById('rename-node').disabled).toBeFalsy();
      });

      it("should disable 'create folder' option", function() {
        expect(menu.findById('create-folder').disabled).toBeTruthy();
      });

      it("should disable 'create page' option", function() {
        expect(menu.findById('create-page').disabled).toBeTruthy();
      });
    });
  });

  describe("menu elements", function() {
    var currentNode = {};
    var item;

    beforeEach(function() {
      menu.node = currentNode;
      menu.fireEvent = jasmine.createSpy('fireEvent');
    });

    describe("'Create folder' option", function() {
      beforeEach(function() {
        item = menu.findById('create-folder');
      });

      it("should have 'Create folder' title", function() {
        expect(item.text).toEqual("Create folder");
      });

      describe("on click", function() {
        it("should fire 'createFolder' event", function() {
          item.fireEvent('click');
          expect(menu.fireEvent).toHaveBeenCalledWith('createFolder', currentNode);
        });
      });
    });

    describe("'Create page' option", function() {
      beforeEach(function() {
        item = menu.findById('create-page');
      });

      it("should have 'Create page' title", function() {
        expect(item.text).toEqual("Create page");
      });

      describe("on click", function() {
        it("should fire 'createPage' event", function() {
          item.fireEvent('click');
          expect(menu.fireEvent).toHaveBeenCalledWith('createPage', currentNode);
        });
      });
    });

    describe("'Rename node' option", function() {
      beforeEach(function() {
        item = menu.findById('rename-node');
      });

      it("should have 'Rename node' title", function() {
        expect(item.text).toEqual("Rename node");
      });

      describe("on click", function() {
        it("should fire 'renameNode' event", function() {
          item.fireEvent('click');
          expect(menu.fireEvent).toHaveBeenCalledWith('renameNode', currentNode);
        });
      });
    });

    describe("'Delete node' option", function() {
      beforeEach(function() {
        item = menu.findById('delete-node');
      });

      it("should have 'Delete node' title", function() {
        expect(item.text).toEqual("Delete node");
      });
      
      describe("on click", function() {
        it("should fire 'deleteNode' event", function() {
          item.fireEvent('click');
          expect(menu.fireEvent).toHaveBeenCalledWith('deleteNode', currentNode);
        });
      });
    });
  });

});
