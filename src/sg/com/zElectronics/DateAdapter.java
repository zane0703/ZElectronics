package sg.com.zElectronics;

import java.util.Date;

import javax.json.bind.adapter.JsonbAdapter;

public class DateAdapter implements JsonbAdapter<Date, Long> {
	@Override
	public Long adaptToJson(Date date) {
		return date.getTime();
	}

	@Override
	public Date adaptFromJson(Long ms) {
		return new Date(ms);
	}
}
