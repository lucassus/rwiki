describe "Rwiki.TreePanel", ->
  treePanel = null
  root = null

  beforeEach ->
    root = new Rwiki.Tree.Node(
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
    )

    treeContent = $('<div />').attr('id', 'tree-div')
    $('#jasmine_content').append(treeContent)

    treePanel = new Rwiki.TreePanel(
      renderTo: 'tree-div',
      loader: new Rwiki.Tree.Loader({preloadChildren: true}),
      root: root
    )

  afterEach ->
    $('#jasmine_content').empty()

  describe ":findNodeByPath function", ->
    it "should find root node", ->
      node = treePanel.findNodeByPath('/Home')
      expect(node).not.toBeNull()

    it "should find '/Home/Test' node", ->
      node = treePanel.findNodeByPath('/Home/Test')

      expect(node).not.toBeNull()
      expect(node.getName()).toEqual('Test')
      expect(node.getPath()).toEqual('/Home/Test')

    it "should find '/Home/Develop/Ruby' node", ->
      node = treePanel.findNodeByPath('/Home/Develop/Ruby')

      expect(node).not.toBeNull()
      expect(node.getName()).toEqual('Ruby')
      expect(node.getPath()).toEqual('/Home/Develop/Ruby')

    it "should not find '/Home/Develop/Non-existing'", ->
      node = treePanel.findNodeByPath('/Home/Develop/Non-existing')
      expect(node).toBeNull()

  describe ":onClick handler", ->
    node = {};

    describe "for leaf node", ->
      beforeEach ->
        node.isLeaf = jasmine.createSpy('node.isLeaf').andReturn(true)
        node.getPath = jasmine.createSpy('node.getPath').andReturn('/Home/path')

        spyOn(treePanel, 'fireEvent');
        treePanel.onClick(node);

      it "should fire event", ->
        expect(treePanel.fireEvent).toHaveBeenCalledWith('rwiki:pageSelected', new Rwiki.Data.Page(path: '/Home/path'))


  describe ":onPageCreated handler", ->
    beforeEach ->
      page = new Rwiki.Data.Page(
        path: '/Home/Develop/New folder',
        parentPath: '/Home/Develop'
      )

      treePanel.onPageCreated(page)

    it "should create and append a valid node", ->
      page = treePanel.findNodeByPath('/Home/Develop/New folder')

      expect(page).not.toBeNull()
      expect(page.getName()).toEqual('New folder')
      expect(page.attributes.text).toEqual('New folder')
      expect(page.isLeaf()).toBeTruthy()

  describe ":onNodeRenamed handler", ->
    beforeEach ->
      node = new Rwiki.Data.Page(
        path: '/Home/Develop/Python',
        oldPath: '/Home/Develop/Ruby'
      )

      treePanel.onPageRenamed(node)

    it "should rename node", ->
      oldNode = treePanel.findNodeByPath('/Home/Develop/Ruby')
      expect(oldNode).toBeNull()

      node = treePanel.findNodeByPath('/Home/Develop/Python')
      expect(node).not.toBeNull()
      expect(node.getName()).toEqual('Python')
      expect(node.isLeaf()).toBeTruthy()

  describe ":onNodeDeleted handler", ->
    beforeEach ->
      page = new Rwiki.Data.Page(path: '/Home/Develop/Ruby')

      treePanel.onPageDeleted(page);

    it "should delete node", ->
      node = treePanel.findNodeByPath('/Home/Develop/Ruby')
      expect(node).toBeNull()
