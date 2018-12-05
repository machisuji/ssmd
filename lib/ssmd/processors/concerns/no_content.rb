##
# This is for annotations which do not have any content, i.e. no enclosed
# text or other annotations. This is mostly relevant for stripping where
# this means that simply removing the annotation would leave an extra space.
#
# Prepending this module to processors for these kinds of annotations
# prevents that.
module NoContent
  def join_parts(prefix, text, suffix)
    leading_ws = /\A\s/
    trailing_ws = /\s\z/

    if text == ""
      if prefix =~ trailing_ws && suffix =~ leading_ws
        prefix.sub(trailing_ws, "") + suffix
      elsif prefix == ""
        suffix.sub(leading_ws, "")
      elsif suffix == ""
        prefix.sub(trailing_ws, "")
      else
        super
      end
    else
      super
    end
  end
end
