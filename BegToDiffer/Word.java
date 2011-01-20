/**
 * The Word class.
 * 
 * Represents a word (usually in the English language) and a value. The value is an integer that can represent anything a integer can represent.
 * 
 * @author Tanner Smith and Ryan Ashcraft
 */
public class Word implements Comparable {
	private String word = "";
	private int value = 0;
	
	/**
	 * Create a new Word with the given word value.
	 * @param word Word value.
	 */
	public Word(String word)
	{
		//Some pre-processing things to do before we set the field variable
		word = word.toLowerCase();
		word = word.replaceAll("\\W", "");
		
		this.word = word;
	}
	
	/**
	 * Create a new Word with the given word value and value.
	 * @param word Word value.
	 * @param value Value value (confusing, eh?).
	 */
	public Word(String word, int value)
	{
		this(word);
		setValue(value);
	}
	
	/**
	 * Set the value of this word to a given value.
	 * @param value New value to set this word to.
	 */
	public void setValue(int value)
	{
		this.value = value;
	}
	
	/**
	 * Gets the value of the value.
	 * @return The value.
	 */
	public int getValue()
	{
		return value;
	}
	
	/**
	 * Get the word that this Word represents.
	 * @return The Word's word (more confusion).
	 */
	public String getWord()
	{
		return word;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
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
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString()
	{
		return word+" ("+value+")";
	}

	/* (non-Javadoc)
	 * @see java.lang.Comparable#compareTo(java.lang.Object)
	 */
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
