require_relative './test_helper_output'

class TestDataImg < Minitest::Test
  include PictureTag
  include TestHelper
  include OutputFormatTestHelper

  def setup
    base_stubs

    @tested = OutputFormats::DataImg.new
  end

  # Test cases:
  # basic img
  def test_img
    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="ss">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  # img with srcset and sizes
  def test_srcset_and_sizes
    stub_sizes_srcset

    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="width srcset" data-sizes="correct sizes">
    HEREDOC

    assert_equal correct, @tested.to_s
  end

  def test_noscript
    PictureTag.stubs(preset: { 'noscript' => true }, nomarkdown: false)

    img_stub = Object.new
    img_stub.stubs(:build_base_img).returns('<img src="good-url">')
    OutputFormats::Img.stubs(:new).returns(img_stub)

    correct = <<~HEREDOC
      <img data-src="good_url" data-srcset="ss">
      <noscript>
        <img src="good-url">
      </noscript>

    HEREDOC

    assert_equal correct, @tested.to_s
  end
end
