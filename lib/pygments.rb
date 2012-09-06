require 'pygments.rb'
require 'hpricot'
require 'cgi'

# Pygments syntax highlighting for pandoc-processed HTML.
# This filter was copied from zmanji/zameermanji.com on github.

class PygmentsFilter < Nanoc::Filter
  identifier :pygments
  type :text

  LANGUAGES = ['ruby', 'vim', 'python', 'text', 'latex']

  def run(content, params = {})
    # The content here should be valid HTML
    # We find code blocks that have been created by pandoc for syntax
    # highlighting. This is a code block with a class name of a programming
    # language.

    post = Hpricot(content)

    LANGUAGES.each do |lang|
      code_blocks = post.search("pre.#{lang} code")
      code_blocks.each do |code_block|
        code = code_block.inner_html
        code = CGI.unescapeHTML(code)
        code = ::Pygments.highlight(code, :lexer => lang, :options => {:encoding => 'utf-8'})
        code_block.parent.swap code
      end
    end

    "poop"

  end
end
