# frozen_string_literal: true

require "test_helper"

class SyntaxHighlightingTest < Minitest::Test
  def test_default_is_to_highlight
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    html = Commonmarker.to_html(code)

    result = <<~HTML
      <span style="color:#b48ead;">def </span><span style="color:#8fa1b3;">hello
      </span><span style="color:#c0c5ce;">  </span><span style="color:#96b5b4;">puts </span><span style="color:#c0c5ce;">&quot;</span><span style="color:#a3be8c;">hello</span><span style="color:#c0c5ce;">&quot;
      </span><span style="color:#b48ead;">end
      </span></code></pre>
    HTML

    lang = %(lang="ruby")
    background = %(style="background-color:#2b303b;")

    assert_match(result, html)
    # doing this because sometimes comrak returns <pre lang="ruby" style="...">
    # and other times <pre style="..." lang="ruby" >
    assert_match(lang, html)
    assert_match(background, html)
  end

  def test_can_disable_highlighting
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    html = Commonmarker.to_html(code, plugins: { syntax_highlighter: nil })

    result = <<~CODE
      <pre lang="ruby"><code>def hello
        puts &quot;hello&quot;
      end
      </code></pre>
    CODE

    assert_equal(result, html)
  end

  def test_non_hash_value_is_an_error
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(TypeError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: "wow!" })
    end
  end

  def test_lack_of_theme_is_an_error
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(TypeError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: {} })
    end
  end

  def test_nil_theme_is_an_error
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(TypeError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: nil } })
    end
  end

  def test_empty_theme_provides_class_highlighting
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    html = Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "" } })

    result = <<~CODE
      <pre class="syntax-highlighting"><code><span class="source ruby"><span class="meta function ruby"><span class="keyword control def ruby">def</span></span><span class="meta function ruby"> <span class="entity name function ruby">hello</span></span>
        <span class="support function builtin ruby">puts</span> <span class="string quoted double ruby"><span class="punctuation definition string begin ruby">&quot;</span>hello<span class="punctuation definition string end ruby">&quot;</span></span>
      <span class="keyword control ruby">end</span>
      </span></code></pre>
    CODE

    assert_equal(result, html)
  end

  def test_can_change_highlighting_theme
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    html = Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "InspiredGitHub" } })
    result = <<~HTML
      <span style="font-weight:bold;color:#a71d5d;">def </span><span style="font-weight:bold;color:#795da3;">hello
      </span><span style="color:#323232;">  </span><span style="color:#62a35c;">puts </span><span style="color:#183691;">&quot;hello&quot;
      </span><span style="font-weight:bold;color:#a71d5d;">end
      </span></code></pre>
    HTML

    lang = %(lang="ruby")
    background = %(style="background-color:#ffffff;")

    assert_match(result, html)
    # doing this because sometimes comrak returns <pre lang="ruby" style="...">
    # and other times <pre style="..." lang="ruby" >
    assert_match(lang, html)
    assert_match(background, html)
  end

  def test_dislikes_missing_theme
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(ArgumentError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "WowieZowie", path: "test/fixtures" } })
    end
  end

  def test_accepts_legit_path
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    html = Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "Monokai", path: FIXTURES_DIR } })
    result = <<~HTML
      <span style="color:#99ff99;">def </span><span style="color:#a6e22e;">hello
      </span><span style="color:#ccccff;">  </span><span style="color:#ffcc66;">puts </span><span style="color:#e6db74;">&quot;hello&quot;
      </span><span style="color:#99ff99;">end
      </span></code></pre>
    HTML

    lang = %(lang="ruby")
    background = %(style="background-color:#323232;")

    assert_match(result, html)
    # doing this because sometimes comrak returns <pre lang="ruby" style="...">
    # and other times <pre style="..." lang="ruby" >
    assert_match(lang, html)
    assert_match(background, html)
  end

  def test_raises_on_bad_path
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(ArgumentError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "Monokai", path: "blerp" } })
    end
  end

  def test_raises_on_bad_key
    code = <<~CODE
      ```ruby
      def hello
        puts "hello"
      end
      ```
    CODE

    assert_raises(ArgumentError) do
      Commonmarker.to_html(code, plugins: { syntax_highlighter: { theme: "Monokai" } })
    end
  end
end
