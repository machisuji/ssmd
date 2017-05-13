class EmphasisProcessor < Processor
  def result
    text = match.captures.first

    "<emphasis>#{text}</emphasis>"
  end

  def regex
    /\*([^\*]+)\*/
  end
end