require 'minitest/autorun'
require 'gpx'

class TrackTest < Minitest::Test
  ONE_TRACK = File.join(File.dirname(__FILE__), 'gpx_files/one_track.gpx')

  def setup
    @gpx_file = GPX::GPXFile.new(gpx_file: ONE_TRACK)
    @track = @gpx_file.tracks.first
  end

  def test_track_read
    assert_equal('ACTIVE LOG', @track.name)
    assert_equal('Comment Log', @track.comment)
    assert_equal('Description Log', @track.description)
    assert_equal(182, @track.points.size)
    assert_equal(8, @track.segments.size)
    assert_in_delta(3.07249668492626, @track.distance, 0.001)
    assert_equal(1267.155, @track.lowest_point.elevation)
    assert_equal(1594.003, @track.highest_point.elevation)
    assert_equal(38.681488, @track.bounds.min_lat)
    assert_equal(-109.606948, @track.bounds.min_lon)
    assert_equal(38.791759, @track.bounds.max_lat)
    assert_equal(-109.447045, @track.bounds.max_lon)
    assert_equal(3036.0, @track.moving_duration)
  end

  def test_track_crop
    area = GPX::Bounds.new(
      min_lat: 38.710000,
      min_lon: -109.600000,
      max_lat: 38.791759,
      max_lon: -109.450000
    )
    @track.crop(area)
    assert_equal('ACTIVE LOG', @track.name)
    assert_equal('Comment Log', @track.comment)
    assert_equal('Description Log', @track.description)
    assert_equal(111, @track.points.size)
    assert_equal(4, @track.segments.size)
    assert_in_delta(1.62136024923607, @track.distance, 0.001)
    assert_equal(1557.954, @track.lowest_point.elevation)
    assert_equal(1582.468, @track.highest_point.elevation)
    assert_equal(38.782511, @track.bounds.min_lat)
    assert_equal(-109.599781, @track.bounds.min_lon)
    assert_equal(38.789527, @track.bounds.max_lat)
    assert_equal(-109.594996, @track.bounds.max_lon)
    assert_equal(1773.0, @track.moving_duration)
  end

  def test_track_delete
    area = GPX::Bounds.new(
      min_lat: 38.710000,
      min_lon: -109.600000,
      max_lat: 38.791759,
      max_lon: -109.450000
    )
    @track.delete_area(area)

    assert_equal(1229.0, @track.moving_duration)
    # puts @track
    assert_equal('ACTIVE LOG', @track.name)
    assert_equal(71, @track.points.size)
    assert_equal(6, @track.segments.size)
    assert_in_delta(1.197905851972874, @track.distance, 0.00000000001)
    assert_equal(1267.155, @track.lowest_point.elevation)
    assert_equal(1594.003, @track.highest_point.elevation)
    assert_equal(38.681488, @track.bounds.min_lat)
    assert_equal(-109.606948, @track.bounds.min_lon)
    assert_equal(38.791759, @track.bounds.max_lat)
    assert_equal(-109.447045, @track.bounds.max_lon)
  end

  def test_append_segment
    trk = GPX::Track.new
    seg = GPX::Segment.new(track: trk)
    pt = GPX::TrackPoint.new(lat: -118, lon: 34)
    seg.append_point(pt)
    trk.append_segment(seg)
    assert_equal(1, trk.points.size)
  end
end
