require 'test_helper'

class BootstrapHelperTest < ActionView::TestCase
  include BootstrapHelper

  def test_glyphicon
    expected = '<span class="glyphicon glyphicon-user"></span>'
    assert_equal expected, glyphicon('user')
  end

  def test_bootstrap_label
    expected = '<span class="label label-default">Test</span>'
    assert_equal expected, bootstrap_label('Test')

    expected = '<span class="label label-warning">Test</span>'
    assert_equal expected, bootstrap_label('Test', 'warning')
  end

  def test_bootstrap_page_title
    expected = '<div class="page-header"><h1 class="">Hello</h1></div>'
    assert_equal expected, bootstrap_page_title('Hello')

    expected = '<div class="page-header"><h1 class="world">Hello</h1></div>'
    assert_equal expected, bootstrap_page_title('Hello', 'world')

  end
end
