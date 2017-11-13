module ApplicationHelper
    def setClassForLabel(attribute)
        (attribute.blank? ? {} : { class: "active" } )
    end
end
