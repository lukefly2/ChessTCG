Card = {
  type,
  team,
  spr,
  loc = "deck",
  cost,
}

function Card:Create(card)
  local card = card or {}
  setmetatable(card, self)
  self.__index = self
  return card
end

function Card:Draw(x, y, selected)
  if selected then
    if self.team == "white" then lg.setColor(colors.blacktransparent) else lg.setColor(colors.whitetransparent) end
  else
    if self.team == "white" then lg.setColor(colors.black) else lg.setColor(colors.white) end
  end
  lg.rectangle("fill", x, y, tilesize * 2, tilesize * 3, 10)
  lg.setFont(chessfont)
  if self.team == "white" then lg.setColor(colors.white) else lg.setColor(colors.black) end
  lg.print(self.spr, x + tilesize * 0.5, y + tilesize * 0.75)
  lg.setFont(font)
  lg.printf(self.type, x, y + tilesize * 1.75, tilesize * 2, "center")
  lg.printf(self.cost, x, y, tilesize * 1.8, "right")
end

function Card:Move(dest)
  if self.team == "white" then
    if dest == "deck" then
      table.insert(white.deck, self)
    elseif dest == "hand" then
      table.insert(white.hand, self)
    end
    if self.loc == "deck" then
      for i, c in ipairs(white.deck) do
        if self == c then
          table.remove(white.deck, i)
        end
      end
    elseif self.loc == "hand" then
      for i, c in ipairs(white.hand) do
        if self == c then
          table.remove(white.hand, i)
        end
      end
    end
  elseif self.team == "black" then
    if dest == "deck" then
      table.insert(black.deck, self)
    elseif dest == "hand" then
      table.insert(black.hand, self)
    end
    if self.loc == "deck" then
      for i, c in ipairs(black.deck) do
        if self == c then
          table.remove(black.deck, i)
        end
      end
    elseif self.loc == "hand" then
      for i, c in ipairs(black.hand) do
        if self == c then
          table.remove(black.hand, i)
        end
      end
    end
  end
  self.loc = dest
end

function Card:Play(r, c)
  for i, p in ipairs(pieces) do
    if p.r == r and p.c == c then
      table.remove(pieces, i)
    end
  end
  table.insert(pieces, Piece:Create{r = r, c = c, team = self.team, type = self.type, spr = self.spr})
  self:Move("deck")
end

function DrawCard(team)
  if team == "white" and #white.deck > 0 and #white.hand < 4 then
    white.deck[1]:Move("hand")
  elseif team == "black" and #black.deck > 0 and #black.hand < 4 then
    black.deck[1]:Move("hand")
  end
end
