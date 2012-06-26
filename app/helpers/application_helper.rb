# -*- coding: utf-8 -*-
module ApplicationHelper

  def yen(o)
    o && number_with_delimiter(o.to_i) + '円'
  end

end
