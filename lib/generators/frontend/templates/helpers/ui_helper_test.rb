require 'test_helper'

class UiHelperTest < ActionView::TestCase
  include UiHelper

  def test_font_awesome
    expected = '<span class="fa fa-cog"></span>'
    assert_equal expected, font_awesome('cog')

    expected = '<span class="fa fa-cog highlight"></span>'
    assert_equal expected, font_awesome('cog', 'highlight')
  end


  def test_link_to_delete
    expected = <<-EOF
<a data-confirm="Are you sure you want to delete this?" rel="nofollow" data-method="delete" href="/url/to/somewhere">delete</a>
    EOF
    assert_equal expected.strip, link_to_delete('/url/to/somewhere')

    expected = <<-EOF
<a data-confirm="Are you sure you want to delete this?" rel="nofollow" data-method="delete" href="/url/to/somewhere">remove</a>
    EOF
    assert_equal expected.strip, link_to_delete('/url/to/somewhere', 'remove')
  end
end
