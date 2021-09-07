package com.jeet.utils;

import java.math.BigDecimal;
import java.util.List;

public class Staff {

	private String name;
	private int age;
	private String position;
	private BigDecimal salary;
	private List<String> skills;
	/**
	 * @return the name
	 */
	protected String getName() {
		return name;
	}
	/**
	 * @param name the name to set
	 */
	protected void setName(String name) {
		this.name = name;
	}
	/**
	 * @return the age
	 */
	protected int getAge() {
		return age;
	}
	/**
	 * @param age the age to set
	 */
	protected void setAge(int age) {
		this.age = age;
	}
	/**
	 * @return the position
	 */
	protected String getPosition() {
		return position;
	}
	/**
	 * @param position the position to set
	 */
	protected void setPosition(String position) {
		this.position = position;
	}
	/**
	 * @return the salary
	 */
	protected BigDecimal getSalary() {
		return salary;
	}
	/**
	 * @param salary the salary to set
	 */
	protected void setSalary(BigDecimal salary) {
		this.salary = salary;
	}
	/**
	 * @return the skills
	 */
	protected List<String> getSkills() {
		return skills;
	}
	/**
	 * @param skills the skills to set
	 */
	protected void setSkills(List<String> skills) {
		this.skills = skills;
	}

	
}