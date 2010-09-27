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

});
