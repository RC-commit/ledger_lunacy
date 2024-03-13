module LedgerFormatter
  extend ActiveSupport::Concern

  def formatted_ledger(ledger)
    if ledger["amount"] > 0
      ledger["formatted_type"] = ledger["type"].capitalize
      ledger["formatted_description"] = description_text(ledger, "source")
      ledger["formatted_date"] = ledger["date"].to_date.strftime("%m/%d/%Y")
      return ledger
    else
      ledger["formatted_type"] = ledger["type"].capitalize
      ledger["formatted_description"] =  description_text(ledger, "destination")
      ledger["formatted_date"] = ledger["date"].to_date.strftime("%m/%d/%Y")
      return ledger
    end
  end

  def description_text(ledger, type)
    obj = ledger[type]
    description = obj["description"]
    if type == "source"
      if obj == nil
        return ledger["type"].capitalize.concat(" from an unknown source")
      else
        if description.present?
          return ledger["type"].capitalize.concat(" from ").concat(description)
        else
          return ledger["type"].capitalize.concat(" from unknown")
        end
      end
    else
      if obj == nil
        return ledger["type"].capitalize.concat(" to unknown account")
      else
        if description.present?
          return ledger["type"].capitalize.concat(" to ").concat(description)
        else
          return ledger["type"].capitalize.concat(" to unknown")
        end
      end
    end
  end
end
