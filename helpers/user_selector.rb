$netids = ["rgirish2", "huang185", "mszymu2", "gegg2","nordeen1", "timm3", "houdek2", "abf34", "uu34", "yfy88", "ddg34", "tddre3", "fff4df", "dfd3"];

class Selector

#    storage = [];
#    @@storage.enq("a")

    def init
#        @@storage.enq("a");
        @@lru = -1;
    end

    def fill(queue, list)
        count = 0;
        while count < list.length
            queue.push(list[count]);
            count = count + 1;
        end
    end

    
    def chose(list)
        number = rand(list.length);
        while @@lru == number
          number = rand(list.length);
        end
        @@lru = number;
        return @@lru;
    end

end

instance = Selector.new
instance.init;

container = []

instance.fill(container, $netids);
puts($netids[instance.chose($netids)]);
