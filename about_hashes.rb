require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutHashes < Neo::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal "uno", hash[:one]
    assert_equal "dos", hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  def test_accessing_hashes_with_fetch
    hash = { :one => "uno" }
    assert_equal "uno", hash.fetch(:one)
    assert_raise(IndexError) do
      hash.fetch(:doesnt_exist)
    end

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?
    # because fucking language ideology was intially developer friendly but shit it has to be confusing as hell doesn't it??? That's why to torture us we have fetch instead of [] so that it throws an exception.

    # but fuck we wouldn't throw an exception if a method doesn't exist or a variable doesn't exists but yeah fucking piece of shit it's utterly the most important thing to throw an exception when you don't find a key in hash set because fuck nil who cares what we have been doing so far.!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => "eins", :two => "dos" }
    assert_equal expected, hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?
    # fuck me i don't know
  end

  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
    # fuck me
  end

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert_equal Array, hash.keys.class
    #fuck me
  end

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
    #fuck me
  end

  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal true, hash != new_hash

    expected = { "jim" => [53,54], "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal false, expected == new_hash
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal 1, hash1[:one]
    assert_equal nil, hash1[:two]

    hash2 = Hash.new("dos") # fuck me this is the default value when a new key si there with no value we then have "dos"
    #fuck me
    hash2[:one] = 1

    assert_equal 1, hash2[:one]
    assert_equal "dos", hash2[:two]
    #fuck me
  end

  def test_default_value_is_the_same_object
    hash = Hash.new([])

    hash[:one] << "uno"
    hash[:two] << "dos"

    # the fucking best thing about ruby is it fucks with your mind.
    # here [] is a fucking single object shared across all the keys so
    # if someone fucks with your wife then it's refected to others as well.
    # at the end everything is fucked up in ruby.

    assert_equal ["uno","dos"], hash[:one]
    assert_equal ["uno","dos"], hash[:two]
    assert_equal ["uno","dos"], hash[:three]
    #fuck me

    assert_equal true, hash[:one].object_id == hash[:two].object_id
    #fuck me twice , fuck me thrice :(:())
  end

  def test_default_value_with_block
    hash = Hash.new {|hash, key| hash[key] = [] }
    # this fucker above runs each time for a key, value so new objects are created. fuckkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ["uno"], hash[:one]
    assert_equal ["dos"], hash[:two]
    assert_equal [], hash[:three]
    # fuck me
  end

  def test_default_value_attribute
    hash = Hash.new

    assert_equal nil, hash[:some_key]

    hash.default = 'peanut'

    assert_equal 'peanut', hash[:some_key]
    #fuck me
  end
end
