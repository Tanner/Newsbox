public class Word implements Comparable {
	private String word = "";
	private int value = 0;
	
	public Word(String word)
	{
		word = word.toLowerCase();
		word = word.replaceAll("\\W", "");
		
		this.word = word;
	}
	
	public Word(String word, int value)
	{
		this(word);
		setValue(value);
	}
	
	public void setValue(int value)
	{
		this.value = value;
	}
	
	public int getValue()
	{
		return value;
	}
	
	public String getWord()
	{
		return word;
	}
	
	public boolean equals(Object o)
	{
		if (o instanceof Word)
		{
			Word objectWord = (Word)o;
			return objectWord.word.equals(word);
		} else if (o instanceof String) {
			String objectString = (String)o;
			return objectString.equals(word);
		}
		
		return false;
	}
	
	public String toString()
	{
		return word+" ("+value+")";
	}

	public int compareTo(Object o)
	{
		//Returns a negative integer, zero, or a positive integer as this object is less than, equal to, or greater than the specified object.
		if (o instanceof Word)
		{
			Word comparisonWord = (Word)o;
			if (value < comparisonWord.value)
			{
				return 1;
			} else if (value > comparisonWord.value) {
				return -1;
			} else {
				return 0;
			}
		} else {
			return -1;
		}
	}
}
