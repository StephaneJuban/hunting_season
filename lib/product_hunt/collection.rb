module ProductHunt
  class Collection
    include Entity

    def created_at
      Time.parse(self["created_at"])
    end

  end
end

