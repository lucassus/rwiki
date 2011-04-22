describe "Rwiki.Tree.Menu", ->
  menu = null

  beforeEach ->
    menu = new Rwiki.Tree.Menu

  describe ":show", ->
    node = {}
    xy = {}

    itShouldDisable = (menuItemId) ->
      it "should disable '" + menuItemId + "' option", ->
        item = menu.findById(menuItemId)
        expect(item).toBeDisabled()

    itShouldEnable = (menuItemId) ->
      it "should enable '" + menuItemId + "' option", ->
        item = menu.findById(menuItemId)
        expect(item).toBeEnabled()

    beforeEach ->
      node.select = jasmine.createSpy('select');
      menu.showAt = jasmine.createSpy('showAt');

      this.addMatchers(
        toBeDisabled: ->
          return this.actual.disabled
        toBeEnabled: ->
          return !this.actual.disabled
      )

    describe "when root node is selected", ->
      beforeEach ->
        node.isRoot = true
        menu.show(node, xy)

      it "should select node", ->
        expect(node.select).toHaveBeenCalled()

      it "should show the menu", ->
        expect(menu.showAt).toHaveBeenCalledWith(xy)

      itShouldEnable('add-page')
      itShouldDisable('delete-page')
      itShouldDisable('rename-page')

    describe "when page node is selected", ->
      beforeEach ->
        node.isRoot = false
        menu.show(node, xy)

      it "should select node", ->
        expect(node.select).toHaveBeenCalled()

      it "should show the menu", ->
        expect(menu.showAt).toHaveBeenCalledWith(xy)

      itShouldEnable('delete-page')
      itShouldEnable('rename-page')
      itShouldEnable('add-page')

  describe "menu elements", ->
    currentNode = {}
    item = null

    beforeEach ->
      menu.node = currentNode
      menu.fireEvent = jasmine.createSpy('fireEvent')

      this.addMatchers(
        toBeTitledAs: (title) ->
          return this.actual.text == title
      )

    describe "'Add page' option", ->
      beforeEach ->
        item = menu.findById('add-page')

      it "should have 'Add page' title", ->
        expect(item).toBeTitledAs("Add page")

    describe "'Rename node' option", ->
      beforeEach ->
        item = menu.findById('rename-page')

      it "should have 'Rename page' title", ->
        expect(item).toBeTitledAs("Rename page")

    describe "'Delete page' option", ->
      beforeEach ->
        item = menu.findById('delete-page')

      it "should have 'Delete page' title", ->
        expect(item).toBeTitledAs("Delete page")

