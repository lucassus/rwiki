describe "Rwiki.Tab.PageTab", ->
  tab = null
  pagePath = '/Home/Page'

  beforeEach ->
    tab = new Rwiki.TabPanel.PageTab()
    tab.setPagePath(pagePath)
