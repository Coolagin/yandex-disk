require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../lib/yandex/disk')

class YandexDiskTest < MiniTest::Unit::TestCase

  def setup
    @disk = Yandex::Disk::Client.new access_token: ENV['YANDEX_DISK_TOKEN']
  end

  def test_initilize
    assert @disk
  end

  def test_put_and_get
    assert @disk.put('README.md', '/README.md')
    remote = @disk.get('/README.md')
    assert_equal File.read('README.md'), remote.body
  end

  # def test_put_large_file
  #   assert @disk.put('large-file.mov', '/large-file.mov')
  # end

  def test_put!
    assert_raises RuntimeError do
      begin
        @disk.put!('README.md', '/folder/that/doesnt/exists/README.md')
      rescue RuntimeError => e
        assert_equal 'store: parent folder was not found', e.message
        raise e
      end
    end
  end

  def test_delete_and_mkdir
    @disk.delete('/a')
    assert !@disk.mkdir('/a/b')
    assert @disk.mkdir('/a')
    assert @disk.mkdir('/a/b')
    assert @disk.delete('/a')
  end

  def test_delete!
    @disk.delete('/a')
    assert_raises RuntimeError do
      begin
        @disk.delete!('/a')
      rescue RuntimeError => e
        assert_equal 'resource not found', e.message
        raise e
      end
    end
  end

  def test_put_in_nested_folder
    assert !@disk.put('README.md', '/new_folder/README.md')
  end

end